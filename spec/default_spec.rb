require 'chefspec'


describe 'sentry::default' do
#    before(:each) do
#        chef_run = ChefSpec::ChefRunner.new
#    end

    it 'installs sentry requirements' do
        chef_run = ChefSpec::ChefRunner.new
        chef_run.converge 'sentry::default'
        expect(chef_run).to install_package 'python-setuptools'
        expect(chef_run).to install_package 'python-dev'
    end

    it 'creates sentry user' do
        chef_run = ChefSpec::ChefRunner.new
        chef_run.node.set['sentry_user'] = 'configured-user'
        chef_run.node.set['sentry_home'] = '/configured/home/dir'
        chef_run.converge 'sentry::default'

        expect(chef_run).to create_user 'configured-user'
        user = chef_run.user 'configured-user'
        expect(user.home).to eq '/configured/home/dir'
    end

    it 'uses sensible default user attributes' do
        chef_run = ChefSpec::ChefRunner.new
        chef_run.converge 'sentry::default'

        expect(chef_run).to create_user 'sentry'
        user = chef_run.user 'sentry'
        expect(user.system).to be_true
        expect(user.shell).to eq '/bin/false'
        expect(user.gid).to eq 'daemon'
        expect(user.home).to eq '/var/sentry'
    end

    it 'creates sentry home directory' do
        chef_run = ChefSpec::ChefRunner.new
        chef_run.converge 'sentry::default'

        expect(chef_run).to create_directory '/var/sentry'
        dir = chef_run.directory '/var/sentry'
        expect(dir.owner).to eq 'sentry'
        expect(dir.mode).to eq 0750
    end

    it 'creates sentry virtual environment' do
        pending 'TODO'
    end

    it 'installs sentry package' do
        chef_run = ChefSpec::ChefRunner.new
        chef_run.converge 'sentry::default'

        expect(chef_run).to install_python_pip 'sentry'
        pending 'should install into virtualenv'
    end

    it 'creates sentry service' do
        pending 'TODO'
    end

end
