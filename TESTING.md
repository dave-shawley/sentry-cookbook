# DEVELOPMENT SETUP

First things first, lets get your ruby environment bootstrapped.  If you
don't have a *good* ruby development environment set up, then download
and install [rvm][1].  After that, we can set up things the way that they
should be set up.

    prompt% rvm use
    Using /Users/daveshawley/.rvm/gems/ruby-1.9.3-p448
    prompt% rvm gemset use sentry-cookbook
    Using ruby-1.9.3-p448 with gemset sentry-cookbook
    prompt% gem install bundler --no-rdoc --no-ri
    Fetching: bundler-1.3.5.gem (100%)
    Successfully installed bundler-1.3.5
    1 gem installed
    prompt% bundle install --quiet

# VERIFYING YOUR ENVIRONMENT

Now you should be set up for development.  Give it a try by running the
unit tests.  The first time through will *vendor* the cookbooks into the
*vendor/cookbooks* directory using Berkshelf.

    prompt% rake spec:unit
    berks install --path vendor/cookbooks
    Using python (1.4.0)
    Using minitest-handler (0.2.1)
    Using sentry (0.1.0)
    Using build-essential (1.4.2)
    Using yum (2.3.2)
    Using chef_handler (1.1.4)
    /Users/daveshawley/.rvm/rubies/ruby-1.9.3-p448/bin/ruby -S rspec ./spec/default_spec.rb
    *.....*
    
    Pending:
      sentry::default installs sentry requirements
        # add to this as needed, remove later if empty
        # ./spec/default_spec.rb:20
      sentry::default creates sentry service
        # TODO
        # ./spec/default_spec.rb:79
    
    Finished in 0.1779 seconds
    7 examples, 0 failures, 2 pending

If you get this far, then things are going pretty well.  Let's try
spinning up the testing VM using [vagrant][2].  If you don't have it
installed, please go and do so.  Install [VirtualBox][3] while you are
at it.

    prompt% vagrant up sentry-testing
    Bringing machine 'sentry-testing' up with 'virtualbox' provider...
    ... a bunch of output here
    [2013-09-25T04:07:22+02:00] INFO: Running report handlers
    Run options: -v --seed 10751
    
    # Running tests:
    
    sentry::default#test_0001_creates the sentry user = 0.00 s = .
    sentry::default#test_0002_creates the sentry virtualenv = 0.00 s = .
    
    Finished tests in 0.004141s, 482.9751 tests/s, 482.9751 assertions/s.
    
    2 tests, 2 assertions, 0 failures, 0 errors, 0 skips
    [2013-09-25T04:07:22+02:00] INFO: Report handlers complete

The **sentry-testing** machine is configured to install the *sentry*
cookbook and run the minitest integration tests.  The last few lines are
the really important ones.


# TESTING DURING DEVELOPMENT

You should be running tests regularly while you are developing.  Chef
recipes are a little different than "normal" code when it comes to testing.
There isn't a lot out there in terms of best practices so I took what I
found and put together my own process.

## Integration Tests

Integration tests bring up a machine image using Vagrant and provisions it
using Chef solo.  The run list for the node includes the [MiniTest Chef
Handler][6] so that the tests in the *files/default/tests/minitest*
directory will be executed during the Chef run.  These assert that the
standard recipe works as advertised.

## Unit Tests

Unit testing is down without bringing up a virtual machine or installing the
recipe anywhere.  I make use of [RSpec][4] and [ChefSpec][5] to unit test
the recipes.  This is automated with `rake spec:unit`.  Where the job of the
integration tests is to ensure that the recipe works as advertised, the unit
tests ensure that all of the configuration options work correctly and all of
the low-level details are spot on.


[1]: http://rvm.io/
[2]: http://vagrantup.com/
[3]: https://www.virtualbox.org/
[4]: http://rspec.info/
[5]: https://github.com/acrmp/chefspec/
[6]: https://github.com/calavera/minitest-chef-handler/
