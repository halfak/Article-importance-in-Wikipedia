"""
Downloads hourly pageview files for a directory.

Usage:
    download_pageviews <web directory> <output directory>
"""
import docopt

def main():
    args = docopt.docopt
