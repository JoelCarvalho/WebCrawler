## Synopsis
Webcrawler Server for Windows and Linux, using ruby, sinatra and capybara.

Can be used like a Selenium Grid Cluster.

## Instalation
Install the webcrawler gem, make some configurations in config.ru, /config/host.rb and /config/drivers.rb if needed
and run the server on the command line.

    gem install bin/webcrawler
    ruby config.ru

Remote Driver on any PC with selenium-server-standalone

    java -jar selenium-server-standalone-2.45.0.jar -role hub -port 8081
    java -jar selenium-server-standalone-2.45.0.jar -role node -hub http://localhost:8081/grid/register


This server can also run using passenger gem on apache and can be deployed using the command line.

    touch tmp/restart.txt

Apache Configuration

    <VirtualHost *:9090>
        ServerName webcrawler.mydev
        DocumentRoot /home/joel/Desktop/Development/WebCrawler/public
        ServerAdmin webmaster@webcrawler.mydev
        <Directory /home/joel/Desktop/Development/WebCrawler/public>
            Require all granted
            Options -MultiViews
            Order allow,deny
            Allow from all
        </Directory>
    </VirtualHost>

## Structure
This project is structured like in the next table.

    - bin
    - lib
        - webcrawler
            *.rb
        webcrawler.rb
    - public
        - img
    - tmp
    config.ru
    README.md
    webcrawler.gemspec

## Contributors
PT Inovação (PTIn) & Release (RELiablE And SEcure Computation Group) at Universidade da Beira Interior (UBI)

*   Main Contributor - Joel Carvalho (UBI)