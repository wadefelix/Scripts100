#! python
#!-*- coding:utf-8 -*-
# --------------------------------------------------------
# Written by Ren Wei
# --------------------------------------------------------

from Crypto.PublicKey import RSA
from Crypto.Signature import PKCS1_v1_5
from Crypto.Hash import SHA
import base64
import os.path as osp

import argparse


'''*RSA签名
* data待签名数据
* 签名用商户私钥，必须是没有经过pkcs8转换的私钥
* 最后的签名，需要用base64编码
* return Sign签名
'''
def sign(data, priKey=None):
    if priKey is None:
        priKey = open(osp.expanduser('~/.ssh/id_rsa'), 'r').read()
    key = RSA.importKey(priKey)
    h = SHA.new(data)
    signer = PKCS1_v1_5.new(key)
    signature = signer.sign(h)
    return base64.b64encode(signature)

'''*RSA验签
* data待签名数据
* signature需要验签的签名
* 验签用公钥
* return 验签是否通过 bool值
'''
def verify(data, signature, pubKey=None):
    if pubKey is None:
        pubKey = open(osp.expanduser('~/.ssh/id_rsa.pub'), 'r').read()
    key = RSA.importKey(pubKey)
    h = SHA.new(data)
    verifier = PKCS1_v1_5.new(key)
    if verifier.verify(h, base64.b64decode(signature)):
        return True
    return False


def parse_args():
    """
    Parse input arguments
    """
    parser = argparse.ArgumentParser(description='signfile')
    parser.add_argument('--infile', dest='infile',
                        help='file to be signed or verified.', type=str)
    parser.add_argument('--outfile', dest='outfile',
                        help='Outputing Signature File',
                        default=None, type=str)
    parser.add_argument('--signature', dest='signature',
                        help='Signature File',
                        default=None, type=str)
    parser.add_argument('--prikey', dest='prikeyfile',
                        help='Private Key File',
                        default=None, type=str)
    parser.add_argument('--pubkey', dest='pubkeyfile',
                        help='Public Key File',
                        default=None, type=str)
    args = parser.parse_args()
    return args

if __name__ == '__main__':
    args = parse_args()

    raw_data = open(args.infile, 'rb').read()

    if args.signature is not None:
        pubkey = None
        if args.pubkeyfile is not None:
            pubkey = open(args.pubkeyfile, 'r').read()
        print verify(raw_data,
                     open(args.signature, 'r').read(),
                     pubkey)
    else:
        prikey = None
        if args.prikeyfile is not None:
            prikey = open(args.prikeyfile, 'r').read()
        sign_data = sign(raw_data,prikey)
        if args.outfile is not None:
            with open(args.outfile,'w') as f:
                f.write(sign_data)
        else:
            print sign_data

