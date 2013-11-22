#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os 
import shutil
import datetime

class OSUtils(object):

    def __init__(self):
        pass

    @staticmethod
    def check_folder(path):
        return os.path.isdir(path)

    @staticmethod
    def create_folder(path):
        try:
            os.makedirs(path)
        except OSError as e:
            print("[-] Directory could not be created: %s" % e)

    @staticmethod
    def remove_empty_folder(path):
        try:
            os.rmdir(path)
        except OSError as e:
            print("[-] Directory could not be removed: %s" % e)

    @staticmethod
    def recursive_remove_folder(path):
        try:
            shutil.rmtree(path, ignore_errors=True)
        except Exception as e:
            print("[-] Directory could not be recursively removed: %s" % e)

    @staticmethod
    def remove_file(path):
        try:
            os.remove(path)
        except OSError as e:
            print("[-] Directory could not be removed: %s" % e)

    @staticmethod
    def ls(path):
        try:
            return os.listdir(path)
        except OSError as e:
            print("[-] Directory could not be recursively removed: %s" % e)

    @staticmethod
    def get_date():
        now = datetime.datetime.now()
        return now.strftime("%d-%m-%Y")

    @staticmethod
    def parse_arguments():
        desc = """
        This library is used to execute any kind of command related with OS.
        For example, actions such as creating directories, checking if files
        exist or getting system date.
        This code is not meant to be used as a standalone utility but used
        as a library instead.
        For this reason, no commands are supported. Enjoy copy-pasting the 
        code.
        """
        import argparse
        parser = argparse.ArgumentParser(description=desc)
        return parser.parse_args()

if __name__ == "__main__":
    OSUtils.create_folder("./created_folder")
    print("[+] New folder created.")
    OSUtils.create_folder("./created_folder_2")
    print("[+] New folder created.")
    OSUtils.remove_empty_folder("./created_folder_2")
    print("[+] Empty folder removed.")
    OSUtils.create_folder("./created_folder_3")
    print("[+] New folder created.")
    f = open("./created_folder_3/file1", "w")
    f.write("Hi")
    f.close()
    print("[+] New file created.")
    f = open("./created_folder_3/file2", "w")
    f.write("Hi")
    f.close()
    print("[+] New file created.")
    print "\t" + str(OSUtils.ls("./created_folder_3/"))
    OSUtils.remove_file("./created_folder_3/file2")
    print("[+] File removed")
    print "\t" + str(OSUtils.ls("./created_folder_3/"))
    OSUtils.recursive_remove_folder("./created_folder_3/")
    print("[+] Folder removed recursively.")
    if not OSUtils.check_folder("./created_foldet_3"):
        print("[+] Removed folder checked.")
    OSUtils.remove_empty_folder("./created_folder")
    print("[+] First folder removed.")
    print OSUtils.get_date()


