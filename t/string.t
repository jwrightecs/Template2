#!/usr/bin/perl -w
#============================================================= -*-perl-*-
#
# t/string.t
#
# Test the String plugin
#
# Written by Andy Wardley <abw@kfs.org>
#
# Copyright (C) 1996-2000 Andy Wardley.  All Rights Reserved.
# Copyright (C) 1998-2000 Canon Research Centre Europe Ltd.
#
# This is free software; you can redistribute it and/or modify it
# under the same terms as Perl itself.
#
# $Id$
#
#========================================================================

use strict;
use lib qw( ./lib ../lib );
use Template::Test;
use Template::Plugin::String;

my $DEBUG = grep /-d/, @ARGV;
#$Template::Parser::DEBUG = $DEBUG;
#$Template::Directive::PRETTY = $DEBUG;

test_expect(\*DATA);

__DATA__
-- test --
[% USE String -%]
string: [[% String.text %]]
-- expect --
string: []

-- test --
[% USE String 'hello world' -%]
string: [[% String.text %]]
-- expect --
string: [hello world]

-- test --
[% USE String text='hello world' -%]
string: [[% String.text %]]
-- expect --
string: [hello world]

-- test --
[% USE String -%]
string: [[% String %]]
-- expect --
string: []

-- test --
[% USE String 'hello world' -%]
string: [[% String %]]
-- expect --
string: [hello world]

-- test --
[% USE String text='hello world' -%]
string: [[% String %]]
-- expect --
string: [hello world]

-- test --
[% USE String text='hello' -%]
string: [[% String.append(' world') %]]
string: [[% String %]]
-- expect --
string: [hello world]
string: [hello world]

-- test --
[% USE String text='hello' -%]
[% copy = String.copy -%]
string: [[% String %]]
string: [[% copy %]]
-- expect --
string: [hello]
string: [hello]

-- test --
[% USE String -%]
[% hi = String.new('hello') -%]
[% lo = String.new('world') -%]
[% hw = String.new(text="$hi $lo") -%]
hi: [[% hi %]]
lo: [[% lo %]]
hw: [[% hw %]]
-- expect --
hi: [hello]
lo: [world]
hw: [hello world]

-- test --
[% USE hi = String 'hello' -%]
[% lo = hi.new('world') -%]
hi: [[% hi %]]
lo: [[% lo %]]
-- expect --
hi: [hello]
lo: [world]

-- test --
[% USE hi = String 'hello' -%]
[% lo = hi.copy -%]
hi: [[% hi %]]
lo: [[% lo %]]
-- expect --
hi: [hello]
lo: [hello]

-- test --
[% USE hi = String 'hello' -%]
[% lo = hi.copy.append(' world') -%]
hi: [[% hi %]]
lo: [[% lo %]]
-- expect --
hi: [hello]
lo: [hello world]

-- test --
[% USE hi = String 'hello' -%]
[% lo = hi.new('hey').append(' world') -%]
hi: [[% hi %]]
lo: [[% lo %]]
-- expect --
hi: [hello]
lo: [hey world]

-- test --
[% USE hi=String "hello world\n" -%]
hi: [[% hi %]]
[% lo = hi.chomp -%]
hi: [[% hi %]]
lo: [[% lo %]]
-- expect --
hi: [hello world
]
hi: [hello world]
lo: [hello world]

-- test --
[% USE foo=String "foop" -%]
[[% foo.chop %]]
[[% foo.chop %]]
-- expect --
[foo]
[fo]

-- test --
[% USE hi=String "hello" -%]
  left: [[% hi.copy.left(11) %]]
 right: [[% hi.copy.right(11) %]]
center: [[% hi.copy.center(11) %]]
centre: [[% hi.copy.centre(12) %]]
-- expect --
  left: [hello      ]
 right: [      hello]
center: [   hello   ]
centre: [   hello    ]

-- test --
[% USE str=String('hello world') -%]
 hi: [[% str.upper %]]
 hi: [[% str %]]
 lo: [[% str.lower %]]
cap: [[% str.capital %]]
-- expect --
 hi: [HELLO WORLD]
 hi: [HELLO WORLD]
 lo: [hello world]
cap: [Hello world]

-- test --
[% USE str=String('hello world') -%]
len: [[% str.length %]]
-- expect --
len: [11]

-- test --
[% USE str=String("   \n\n\t\r hello\nworld\n\r  \n \r") -%]
[[% str.trim %]]
-- expect --
[hello
world]

-- test --
[% USE str=String("   \n\n\t\r hello  \n \n\r world\n\r  \n \r") -%]
[[% str.collapse %]]
-- expect --
[hello world]

-- test --
[% USE str=String("hello") -%]
[[% str.append(' world') %]]
[[% str.prepend('well, ') %]]
-- expect --
[hello world]
[well, hello world]

-- test --
[% USE str=String("hello") -%]
[[% str.push(' world') %]]
[[% str.unshift('well, ') %]]
-- expect --
[hello world]
[well, hello world]

-- test --
[% USE str=String('foo bar') -%]
[[% str.copy.pop(' bar') %]]
[[% str.copy.shift('foo ') %]]
-- expect --
[foo]
[bar]

-- test --
[% USE str=String('Hello World') -%]
[[% str.copy.truncate(5) %]]
[[% str.copy.truncate(8, '...') %]]
-- expect --
[Hello]
[Hello...]

-- test --
[% USE String('foo') -%]
[[% String.append(' ').repeat(4) %]]
-- expect --
[foo foo foo foo ]

-- test --
[% USE String('foo') -%]
[% String.format("[%s]") %]
-- expect --
[foo]

-- test --
[% USE String('foo bar foo baz') -%]
[[% String.replace('foo', 'oof') %]]
-- expect --
[oof bar oof baz]

-- test --
[% USE String('foo bar foo baz') -%]
[[% String.copy.remove('foo\s*') %]]
[[% String.copy.remove('ba[rz]\s*') %]]
-- expect --
[bar baz]
[foo foo ]

-- test --
[% USE String('foo bar foo baz') -%]
[[% String.split.join(', ') %]]
-- expect --
[foo, bar, foo, baz]

-- test --
[% USE String('foo bar foo baz') -%]
[[% String.split(' bar ').join(', ') %]]
-- expect --
[foo, foo baz]

-- test --
[% USE String('foo bar foo baz') -%]
[[% String.split(' bar ').join(', ') %]]
-- expect --
[foo, foo baz]

-- test --
[% USE String('foo bar foo baz') -%]
[[% String.split('\s+').join(', ') %]]
-- expect --
[foo, bar, foo, baz]

-- test --
[% USE String('foo bar foo baz') -%]
[[% String.split('\s+', 2).join(', ') %]]
-- expect --
[foo, bar foo baz]


-- test --
[% USE String('foo bar foo baz') -%]
[% String.search('foo') ? 'ok' : 'not ok' %]
[% String.search('fooz') ? 'not ok' : 'ok' %]
[% String.search('^foo') ? 'ok' : 'not ok' %]
[% String.search('^bar') ? 'not ok' : 'ok' %]
-- expect --
ok
ok
ok
ok


-- test --
[% USE String 'foo < bar' filter='html' -%]
[% String %]
-- expect --
foo &lt; bar

-- test --
[% USE String 'foo bar' filter='uri' -%]
[% String %]
-- expect --
foo%20bar

-- test --
[% USE String 'foo bar' filters='uri' -%]
[% String %]
-- expect --
foo%20bar

-- test --
[% USE String '   foo bar    ' filters=['trim' 'uri'] -%]
[[% String %]]
-- expect --
[foo%20bar]

-- test --
[% USE String '   foo bar    ' filter='trim, uri' -%]
[[% String %]]
-- expect --
[foo%20bar]

-- test --
[% USE String '   foo bar    ' filters='trim, uri' -%]
[[% String %]]
-- expect --
[foo%20bar]

-- test --
[% USE String 'foo bar' filters={ replace=['bar', 'baz'],
				  trim='', uri='' } -%]
[[% String %]]
-- expect --
[foo%20baz]

-- test --
[% USE String 'foo bar' filters=[ 'replace', ['bar', 'baz'],
				  'trim', 'uri' ] -%]
[[% String %]]
-- expect --
[foo%20baz]

-- test --
[% USE String 'foo bar' -%]
[% String %]
[% String.filter('uri') %]
[% String.filter('replace', 'bar', 'baz') %]
[% String.output_filter('uri') -%]
[% String %]
-- expect --
foo bar
foo%20bar
foo baz
foo%20bar