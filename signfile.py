#! python
# -*- coding:utf-8 -*-
# --------------------------------------------------------
# Written by Ren Wei
# --------------------------------------------------------

from Crypto.PublicKey import RSA
from Crypto.Signature import PKCS1_v1_5
from Crypto.Cipher import PKCS1_v1_5 as Cipher_pkcs1_v1_5
from Crypto import Random
from Crypto.Hash import SHA
import base64
import os.path as osp
import argparse


def sign(data, priKey=None):
    """
    使用私钥签名
    Args:
        data: 待签名数据
        priKey: 私钥。默认使用用户的默认私钥 ~/.ssh/id_rsa

    Returns:
        签名
    """
    if priKey is None:
        priKey = open(osp.expanduser('~/.ssh/id_rsa'), 'r').read()
    key = RSA.importKey(priKey)
    h = SHA.new(data)
    signer = PKCS1_v1_5.new(key)
    signature = signer.sign(h)
    return base64.b64encode(signature)


def verify(data, signature, pubKey=None):
    """
    使用公钥验证签名
    Args:
        data: 原始数据
        signature: 签名
        pubKey: 公钥。默认使用用户的默认公钥 ~/.ssh/id_rsa.pub

    Returns:
        验证通过与否
    """
    if pubKey is None:
        pubKey = open(osp.expanduser('~/.ssh/id_rsa.pub'), 'r').read()
    key = RSA.importKey(pubKey)
    h = SHA.new(data)
    verifier = PKCS1_v1_5.new(key)
    if verifier.verify(h, base64.b64decode(signature)):
        return True
    return False


def encrypt(data, pubKey=None):
    """
    使用公钥加密数据
    Args:
        data: 需要加密的数据
        pubKey: 公钥。默认使用用户的默认公钥 ~/.ssh/id_rsa.pub

    Returns:
        加密后的数据
    """
    if pubKey is None:
        pubKey = open(osp.expanduser('~/.ssh/id_rsa.pub'), 'r').read()
    key = RSA.importKey(pubKey)
    cipher = Cipher_pkcs1_v1_5.new(key)
    cipher_text = base64.b64encode(cipher.encrypt(data))
    return cipher_text


def decrypt(data, priKey=None):
    """
    使用私钥解密数据
    Args:
        data: 需要解密的数据
        priKey: 私钥。默认使用用户的默认私钥 ~/.ssh/id_rsa

    Returns:
        解密后的数据
    """
    if priKey is None:
        priKey = open(osp.expanduser('~/.ssh/id_rsa'), 'r').read()
    key = RSA.importKey(priKey)
    cipher = Cipher_pkcs1_v1_5.new(key)
    random_generator = Random.new().read
    text = cipher.decrypt(base64.b64decode(data), random_generator)
    return text


def parse_args():
    """
    Parse input arguments
    """
    parser = argparse.ArgumentParser(description='RSA signature, verify, encrypt and decrypt Samples')
    parser.add_argument('--infile', dest='infile',
                        help='file to be handled.', type=str)
    parser.add_argument('--outfile', dest='outfile',
                        help='file to be output.',
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
    parser.add_argument('--encrypt', action="store_true", help='encrypt the infile to outfile')
    parser.add_argument('--decrypt', action="store_true", help='decrypt the infile to outfile')
    args = parser.parse_args()
    return args


if __name__ == '__main__':
    args = parse_args()

    raw_data = open(args.infile, 'rb').read()
    func = None
    params = [raw_data]

    if args.encrypt:
        func = encrypt
        pubkey = None
        if args.pubkeyfile is not None:
            pubkey = open(args.pubkeyfile, 'r').read()
        params.append(pubkey)
    elif args.decrypt:
        func = decrypt
        prikey = None
        if args.prikeyfile is not None:
            prikey = open(args.prikeyfile, 'r').read()
        params.append(prikey)
    elif args.signature is not None:
        func = verify
        pubkey = None
        if args.pubkeyfile is not None:
            pubkey = open(args.pubkeyfile, 'r').read()
        params.append(open(args.signature, 'r').read())
        params.append(pubkey)
    else:
        func = sign
        prikey = None
        if args.prikeyfile is not None:
            prikey = open(args.prikeyfile, 'r').read()
        params.append(prikey)

    data = func(*params)
    if args.outfile is not None:
        with open(args.outfile,'w') as f:
            f.write(data)
    else:
        print data