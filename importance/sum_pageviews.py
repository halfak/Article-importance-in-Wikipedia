"""
Sums page view counts from hourly data.

Usage:
    sum_pageviews (-h|--help)
    sum_pageviews <path>... --api=<uri> --projects=<names>
    
Options:
    -h|--help           Shows this documentation
    <path>...           A set of hourly pageview files to process
    --projects=<names>  A list of "|" delimited project identifiers to match
                        in the hourly view logs (e.g. "en|en.mw")
    --api=<uri>         The URI for accessing the relevant MediaWiki instance
                        for processing namespaces and titles
"""
import gzip
import heapq
import sys
import urllib.parse
from collections import namedtuple
from itertools import groupby

import docopt
import mw.api
import mw.lib.title

from more_itertools import peekable


def sequence(*iterables, key=lambda i:i):
    
    # Prepare the iterable queue
    nextq = []
    for i, iterable in enumerate(iterables):
        iterable = peekable(iterable)
        try:
            heapq.heappush(nextq, ((iterable.peek(), i), iterable))
        except StopIteration:
            # Na. We're cool
            pass
    
    while len(nextq) > 0:
        (_, i), iterable = heapq.heappop(nextq)
        
        yield next(iterable)
        
        try:
            heapq.heappush(nextq, ((iterable.peek(), i), iterable))
        except:
            # Again, we're cool.
            pass
        
    

HourViews = namedtuple("HourViews", ['project', 'page_name', 'views',
                                      'bytes_returned'])

def open_hour_file(path, projects):
    
    with gzip.open(path, mode="rt", encoding="utf-8", errors="replace") as f:
        yield from read_hour_file(f, projects)

def read_hour_file(f, projects):
    projects = set(projects)
    for line in f:
        project, page_name, views, bytes = line.strip().split(" ")
        hourviews = HourViews(project, page_name, int(views),
                              int(bytes))
        
        if hourviews.project in projects:
            yield hourviews

def sequence_hour_files(hour_files):
    return sequence(*hour_files, key=lambda h:h.page_name)

def group_page_hours(sequenced_hours):
    return groupby(sequenced_hours, key=lambda h:h.page_name)

def main():
    args = docopt.docopt(__doc__)
    
    run(args['<path>'],
        [p.strip() for p in (args['--projects'] or "").split(",")],
        args['--api'])
    
def encode(val):
    return val.replace("\t", "\\t").replace("\n", "\\n")
    

def run(paths, projects, api_uri):
    
    sys.stderr.write("Building title parser from the API.\n")
    sys.stderr.flush()
    api = mw.api.Session(api_uri)
    title_parser = mw.lib.title.Parser.from_api(api)
    
    sys.stderr.write("Setting up hour file readers.\n")
    sys.stderr.flush()
    
    hour_files = [open_hour_file(path, projects) for path in paths]
    page_groups = group_page_hours(sequence_hour_files(hour_files))
                          
    sys.stderr.write("Starting main loop.\n")
    sys.stderr.flush()
    for page_name, hours in page_groups:
        sys.stderr.write(".")
        page_name = urllib.parse.unquote(page_name) # Decodes %xx url encoding
                                                    # sequencese.
        namespace, title = title_parser.parse(page_name)
        
        views = sum(h.views for h in hours)
        
        print("{0}\t{1}\t{2}".format(namespace, encode(title), views))
