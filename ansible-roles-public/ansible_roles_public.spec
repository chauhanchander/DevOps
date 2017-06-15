Name:           ansible_roles_public
Summary:        Ansible Roles
Version:        1.1
Release:        %{?BUILD_NUMBER}

Group:          Ansible/Roles
License:        Cablevision Systems Corp Internal use only

BuildArch:	noarch
BuildRoot:	%{_tmppath}/%{name}-%{version}-root

Packager:	Eric J. McAlvin <emcalvin@cablevision.com>
Prefix:		/home/ansible/ansible-roles-public
URL:	        https://bitbucket.cablevision.com/projects/EITDO/repos/ansible-roles-public
Provides:	ansible_roles

%description
A set of Ansible Roles written by EIT DevOps and community

%prep

%build

%install
rm -rf $RPM_BUILD_ROOT
install -d -m 755 $RPM_BUILD_ROOT/home/ansible/ansible-roles-public/
cp -R ../SOURCES/ansible-roles-public/* $RPM_BUILD_ROOT/home/ansible/ansible-roles-public/

%post

%files
%defattr(-,ansible,ansible,-)
/home/ansible/ansible-roles-public/
%exclude /home/ansible/ansible-roles-public/ansible_roles_public.spec
%exclude /home/ansible/ansible-roles-public/install

%changelog
