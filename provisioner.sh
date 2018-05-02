#!/bin/sh

yum -y install openldap-servers openldap-clients epel-release
yum -y install phpldapadmin

cp /vagrant/phpldapadmin.conf /etc/httpd/conf.d/
cp /vagrant/config.php /etc/phpldapadmin/

chkconfig --level 345 httpd on
service httpd start

mkdir /var/lib/ldap/jp
chown ldap:ldap /var/lib/ldap/jp

chkconfig --level 345 slapd on
service slapd start

ldapmodify -Y EXTERNAL -H ldapi:// -f /vagrant/mt/t/ldif/cn=config.ldif
ldapadd -f /vagrant/mt/t/ldif/example_com.ldif -x -D "cn=admin,dc=example,dc=com" -w secret
ldapadd -f /vagrant/mt/t/ldif/example_jp.ldif -x -D "cn=admin,dc=example,dc=jp" -w secret
ldapadd -f /vagrant/mt/t/ldif/domain1_example_jp.ldif -x -D "cn=admin,dc=example,dc=jp" -w secret
ldapadd -f /vagrant/mt/t/ldif/domain2_example_jp.ldif -x -D "cn=admin,dc=example,dc=jp" -w secret

