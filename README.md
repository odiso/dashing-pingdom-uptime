dashing-pingdom-uptime
======================

Dashing widget to display Pingdom Uptime of selected check

I'm sorry if the code is not very well, but I had never made ruby and I'm not a developer, so be indulgent with me

##Dependencies

[rest-client](http://rubydoc.info/gems/rest-client/1.6.7/frames)

Add it to dashing's gemfile:

    gem 'rest-client'
    
and run `bundle install`. Everything should work now :)

How to use it
=============

Put this file pingdomuptime.rb on jobs folder

Put the directory pingdomuptime on widgets folder

Personnalize pingdomuptime.rb file and enjoy !!!

##Settings

Modify the file pingdomuptime.rb and adapt this value :

    api_key = ENV['PINGDOM_API_KEY'] || ''
    user = ENV['PINGDOM_USER'] || ''
    password = ENV['PINGDOM_PASSWORD'] || ''


You can choose to filter what you want to monitor, it's based to check name (If you put nothing, you will get all checks)

    checkName = "toto"


## Adding this widget to your dashboard

To include the widget in a dashboard, add the following snippet to the dashboard layout file :

    <li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
     <div data-id="pingdomuptime" data-view="Pingdomuptime" data-title="Pingdom Uptime" data-moreinfo="more-info" data-suffix="%"></div>
    </li>

Appearance
==========

![alt tag](https://raw.github.com/pydubreucq/dashing-pingdom-uptime/master/screenshot/pingdomuptime.png)


Contributor
===========

This widget was made by <a href="http://blog.admin-linux.org" target="_blank">Pierre-Yves Dubreucq</a> with the support of <a href="http://www.odiso.com/" target="_blank">Odiso</a>

This widget was inspired by this https://gist.github.com/jwalton/6625777

Pinddom is a trademard https://www.pingdom.com/

Licence
=======

This widget is under GPL v3 Licence

http://www.gnu.org/copyleft/gpl.html
