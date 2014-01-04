# DEVELOPMENT SETUP

First things first, lets get your ruby environment bootstrapped.  If you
don't have a *good* ruby development environment set up, then install
[rbenv][1].  After that, we can set up things the way that they should
be set up.

    prompt% git clone https://github.com/sstephenson/rbenv.git $HOME/.rbenv

Add the following lines to your shell initializatin file (e.g.,
*$HOME/.zshrc*, *$HOME/.bashrc*).

    export PATH="$HOME/.rbenv/bin;$PATH"
    eval "$(rbenv init -)"

Run **$HOME/.rbenv/bin/rbenv init** from the command line if you are
paranoid enough to care.

Next we get to install a ruby version to work with.  This step makes
use of the [ruby-build][12] plugin to rbenv.

    prompt% git clone https://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build
    prompt% rbenv install 1.9.3-p448
    prompt% rehash

This project manages its ruby gem dependencies using the [bundler][13]
utility and a *Gemfile*.  You will beed to install this into your new
environment as well:

    prompt% gem install bundler
    prompt% rbenv rehash

Now you can slurp in all of the dependencies using the Bundler utility.
Run the following command from within the project directory.  The ruby
version is *wired* by the *.ruby-version* file at the root of the
directory.

    prompt% bundle install
    prompt% rbenv rehash

The bundler manages a sandboxed Gem environment and runs commands within
a sandbox containing only specific versions of specific gems.  The
versions are pinned in the *Gemfile* as necessary.  When you install them
with the bundle utility, it creates a manifest of the precise versions of
the installed gems and stores the list in *Gemfile.lock*.

# VERIFYING YOUR ENVIRONMENT

Now you should be set up for development.  Give it a try by running the
unit tests.

    prompt% bundle exec rake spec:unit
    /.../bin/ruby -S rspec ./spec/default_spec.rb

    sentry::default
      creates sentry virtual environment
      creates sentry home directory
      creates sentry user
      creates sentry group
      installs sentry requirements
      uses sensible default user attributes
    
    Finished in 0.41714 seconds
    6 examples, 0 failures
    
    Randomized with seed 6476

If you get this far, then things are going pretty well.  Let's try
spinning up the testing VM using [vagrant][2].  If you don't have it
installed, please go and do so.  Install [VirtualBox][3] while you are
at it.

    prompt% vagrant up sentry-testing
    Bringing machine 'sentry-testing' up with 'virtualbox' provider...
    ... a bunch of output here
    [2013-12-08T14:41:52+00:00] INFO: Chef Run complete in 61.331066165 seconds
    [2013-12-08T14:41:52+00:00] INFO: Running report handlers
    [2013-12-08T14:41:52+00:00] INFO: Running BATS tests in /vagrant/test
    [2013-12-08T14:41:52+00:00] INFO: BATS: 1..3
    [2013-12-08T14:41:52+00:00] INFO: BATS: ok 1 sentry user created
    [2013-12-08T14:41:52+00:00] INFO: BATS: ok 2 sentry group created
    [2013-12-08T14:41:52+00:00] INFO: BATS: ok 3 sentry virtualenv exists
    [2013-12-08T14:41:52+00:00] INFO: Report handlers complete

The **sentry-testing** machine is configured to install the *sentry*
cookbook and run the BATS integration tests.  The last few lines are the
really important ones.

# TESTING DURING DEVELOPMENT

You should be running tests regularly while you are developing.  Chef
recipes are a little different than "normal" code when it comes to testing.
There isn't a lot out there in terms of best practices so I took what I
found and put together a process based on some of the excellent  work done
by [Seth Vargo][8], [Fletcher Nichol][9], [David Calavera][10], and
countless others.

## Integration Tests

Integration tests bring up a machine image using Vagrant and provisions it
using Chef solo.  The run list for the node includes the [BATS runner Chef
Handler][6] so that the tests in the *test/integration/* directory will be
executed during the Chef run.  These assert that the standard recipe works
as advertised.

The tests are written using [Sam Stephenson's BATS][11].  It runs test files
that are essentially shell script snippets.  If any statement fails, then
the test fails.  This makes it very easy to perform assertions on the post-
converge state of the node without caring about how it got to that state.

## Unit Tests

Unit testing is down without bringing up a virtual machine or installing the
recipe anywhere.  I make use of [RSpec][4] and [ChefSpec][5] to unit test
the recipes.  This is automated with `rake spec:unit`.  Where the job of the
integration tests is to ensure that the recipe works as advertised, the unit
tests ensure that all of the configuration options work correctly and all of
the low-level details are spot on.

One of the difficulties associated with running the unit tests is that you
absolutely have to *vendor* the Sentry cookbook after changing it.  You might
be able to overcome this with a local knife configuration file, but I decided
to take advantage of the fact that the *vendor* directory is added to the
cookbook path automatically.  The *spec/spec_helper.rb* file uses the *berks*
utility to *vendor* the cookbooks before each test.  This adds less than a
second to each test run so you won't even notice that it is happening.

## Running a TDD Loop
The excellent [guard][7] utility can run both integration and unit tests
while you develop.  The provided _Guardfile_ will run RSpec or *vagrant
provision* when a spec, a BATS test, or something important within the
recipe changes.  I usually leave it running in another console while I am
working through a feature.


[1]: https://github.com/sstephenson/rbenv#installation
[2]: http://vagrantup.com/
[3]: https://www.virtualbox.org/
[4]: http://rspec.info/
[5]: https://github.com/acrmp/chefspec/
[6]: https://github.com/dave-shawley/bats-runner
[7]: https://github.com/guard/guard/wiki/
[8]: https://github.com/sethvargo
[9]: https://github.com/test-kitchen/test-kitchen
[10]: https://github.com/calavera/minitest-chef-handler
[11]: https://github.com/sstephenson/bats
[12]: https://github.com/sstephenson/ruby-build
[13]: http://bundler.io
