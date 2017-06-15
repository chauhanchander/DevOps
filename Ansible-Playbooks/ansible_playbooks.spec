Name:           ansible_playbooks
Summary:        Ansible Playbooks
Version:        1.3
Release:        %{?BUILD_NUMBER}

Group:          Ansible/Playbooks
License:        Cablevision Systems Corp Internal use only

BuildArch:	noarch
BuildRoot:	%{_tmppath}/%{name}-%{version}-root

Packager:	Eric J. McAlvin <emcalvin@cablevision.com>
Prefix:		/home/ansible/ansible-playbooks
URL:	        https://bitbucket.cablevision.com/projects/EITDO/repos/ansible-playbooks
Provides:	ansible_playbooks

%description
A set of Ansible Playbooks written by EIT DevOps

%prep

%build

%install
rm -rf $RPM_BUILD_ROOT
install -d -m 755 $RPM_BUILD_ROOT/home/ansible/ansible-playbooks/
cp -R ../SOURCES/ansible-playbooks/* $RPM_BUILD_ROOT/home/ansible/ansible-playbooks/

%post

%files
%defattr(-,ansible,ansible,-)
/home/ansible/ansible-playbooks/
%exclude /home/ansible/ansible-playbooks/ansible_playbooks.spec
%exclude /home/ansible/ansible-playbooks/install
%config(noreplace) /home/ansible/ansible-playbooks/jboss_stack_provision_input_example.yml
%config(noreplace) /home/ansible/ansible-playbooks/postgres_stack_provision_input_example.yml


%changelog
