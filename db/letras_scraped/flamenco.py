# -*- coding: utf-8 -*-

from operator import itemgetter, attrgetter
import grequests
from BeautifulSoup import BeautifulSoup


def make_soup(response):
    """
    Create a ``BeautifulSoup.BeautifulSoup`` instance out of a `response`.
    """
    return BeautifulSoup(response.content)


def links(lis):
    for li in lis:
        yield li.findAll('a')[0]


# Functions for extracting text and href from <a> elements

text = attrgetter('text')

def href(a):
    return ''.join([URL, a['href']])

def href_and_text(anchors):
    return dict([(href(a), text(a)) for a in anchors])



URL = "http://www.telefonica.net/web2/flamencoletras/"


response = grequests.get(URL).send()
index = make_soup(response)

lis = index.findAll('li')
anchors = links(lis)


def save_to_file(filename, text):
    clean_filename = filename.replace('/', '-').strip('"')
    with open(clean_filename, 'w+') as f:
        f.write(text.encode('utf-8'))

def html_to_poetry(p):
    return str(p)[4:][:-4].replace('<br />', '')

def to_poems(ps):
    is_title = lambda p: p.findAll('h4')

    text = ''
    for p in ps:
        if is_title(p):
            title = p.findAll('h4')[0].text
            text += '\n\n'.join(['', title.capitalize(), ''])
        else:
            text += '\n'.join(['', html_to_poetry(p).decode('utf-8')])

    return text[2:]


url_name = href_and_text(anchors)


rs = (grequests.get(url) for url in url_name.keys())

for response in grequests.imap(rs):
    filename = '.'.join([url_name[response.url], 'txt'])
    lyrics = make_soup(response)
    ps = lyrics.findAll('p')[2:]
    save_to_file(filename, to_poems(ps))
