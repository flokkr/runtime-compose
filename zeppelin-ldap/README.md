
## Example to use LDAP authentication with Apache Zeppelin

LDAP webui url: http://localhost:6443

Default credentials:

 * User: cn=admin,dc=example,dc=org
 * Password: admin

Example user:

```
dn: uid=test,dc=example,dc=org
cn: test
displayname: Test Bela
givenname: Firstname
mail: test@example.org
objectclass: top
objectclass: person
objectclass: organizationalPerson
objectclass: inetOrgPerson
sn: Lastname
uid: test
userpassword: password
```


Example group:

```
dn: cn=group1,dc=example,dc=org
objectClass: top
objectClass: groupOfNames
cn: group1
member: uid=test,dc=example,dc=org
```
