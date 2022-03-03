#!/usr/bin/env python

from setuptools import setup

setup(name='hellowhl',
      version='1.0',
      author='An Awesome Coder',
      # list folders, not files
      packages=['hellowhl'],
      scripts=[],
      package_data={},
      license='LICENSE.txt',
      description='print hello-whl.',
      url='',
      long_description=open('README.txt').read(),
      install_requires=[],
      )
