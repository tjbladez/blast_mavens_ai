require "rubygems"
require "bundler"

Bundler.require(:default)

BLAST_ROOT = File.expand_path('../..', __FILE__)
BLAST_IMG_PATH = BLAST_ROOT + '/resources/images/'
BLAST_MAP_PATH = BLAST_ROOT + '/resources/maps/'
BLAST_SND_PATH = BLAST_ROOT + '/resources/sounds/'
BLAST_LIB_ROOT = BLAST_ROOT + '/lib/'

$:.unshift BLAST_LIB_ROOT

require 'processor'