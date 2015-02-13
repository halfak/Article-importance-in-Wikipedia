"""
Extracts PubMed IDs from articles

Usage:
    extract_pmids -h | --help
    extract_pmids --api=<url> --threads=<count> <dump_path>...
    
Options:
    -h --help          Shows this documentation
    --api=<path>       The URL of the mediawiki API to get info from
    --threads=<count>  The number of threads to start
"""

import re
import sys
import traceback
from multiprocessing import cpu_count

import docopt
from mw import api, xml_dump
from mw.lib import title


#from mwparserfromhell import parse


def encode(val):
    
    if val is None:
        val = "NULL"
    if not isinstance(val, str):
        val = str(val)
        
    return val.replace("\t", "\\t").replace("\n", "\\n")

#def extract_wikilinks(text):
#    return (link.title for link in parse(text).ifilter_wikilinks())

LINK_RE = re.compile(r"\[\[([^\]\|]+)(\|[[^\]\|]*)?")

def extract_wikilinks(text):
    return (m.group(1) for m in LINK_RE.finditer(text))

assert list(extract_wikilinks("foo [[bar]], [[herp|derp]],"
                              " [[Talk:Foo|Foo]] [[mw:Hats:Pants]]")) == \
            ["bar", "herp", "Talk:Foo", "mw:Hats:Pants"]

def extract_and_parse_inlinks(text, title_parser):
    for i, wikilink in enumerate(extract_wikilinks(text)):
        ns, title = title_parser.parse(wikilink)

        yield ns, title.split("#", 1)[0]

def main():
    args = docopt.docopt(__doc__)
    
    session = api.Session(args['--api'])
    title_parser = title.Parser.from_api(session)
    threads = int(args['--threads'] or cpu_count())
    
    
    def process_dump(dump, path):
        
        for page in dump:
            
            for revision in page:
                try:
                    links = set(extract_and_parse_inlinks(revision.text,
                                                          title_parser))
                    for ns, title in links:
                        yield page.id, ns, title

                except Exception as e:
                    sys.stderr.write(traceback.format_exc())
		            
        
    print("from_id\tto_ns\tto_title")
    
    link_infos = xml_dump.map(args['<dump_path>'],
                              process_dump,
                              threads=threads)
    
    for from_id, to_ns, to_title in link_infos:
        
        print('{0}\t{1}\t{2}'.format(from_id, to_ns, encode(to_title)))
