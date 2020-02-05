# Redmine Drafts Plugin

This plugin is an answer to issue [#2910](http://www.redmine.org/issues/2910) : if you accidentally leave an issue while editing it, and if it's very large, it can drive you crazy to lose everything you typed before. There can be at least 2 approaches to avoid losing data this way :
* forbid leaving the page with a javascript warning
* saving drafts periodically so you can find and restore it when you're back on the issue page : this is the method this plugin tries to implement

## Install

You can first take a look at general instructions for plugins [here](http://www.redmine.org/wiki/redmine/Plugins).

Then :
* clone this repository in your `plugins/` directory ; if you have a doubt you put it at the good level, you can check you have a `plugins/redmine_drafts/init.rb` file
* run the migrations and copy assets, from your redmine root directory with the command : `RAILS_ENV=production rake redmine:plugins`
* restart your Redmine instance (depends on how you host it)

## Test status

|Plugin branch| Redmine Version   | Test Status       |
|-------------|-------------------|-------------------|
|master       | master            | [![Build1][1]][5] |  
|master       | 4.1.0             | [![Build1][2]][5] |  
|master       | 4.0.6             | [![Build2][3]][5] |

[1]: https://travis-matrix-badges.herokuapp.com/repos/jbbarth/redmine_drafts/branches/master/1
[2]: https://travis-matrix-badges.herokuapp.com/repos/jbbarth/redmine_drafts/branches/master/2
[3]: https://travis-matrix-badges.herokuapp.com/repos/jbbarth/redmine_drafts/branches/master/3
[5]: https://travis-ci.com/jbbarth/redmine_drafts

## Contribute

If you like this plugin, it's a good idea to contribute :
* by giving feed back on what is cool, what should be improved
* by reporting bugs : you can open issues directly on github for the moment
* by forking it and sending pull request if you have a patch or a feature you want to implement
