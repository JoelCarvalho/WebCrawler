#!/bin/bash
rm bin/*.gem
gem uninstall webcrawler
gem build webcrawler.gemspec
gem install webcrawler
mv *.gem bin/
touch tmp/restart.txt
