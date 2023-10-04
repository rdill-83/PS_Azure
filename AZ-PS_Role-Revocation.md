## Azure RBAC Role Revocation

### View Existing Azure RBAC Roles Assigned to User:
```
Get-AZRoleAssignment | Where {$_.SignInName -like '<User.Name*>'} | FL DisplayName,SignInName,ObjectType,RoleDefinitionName,Scope
```
### Remove All Azure RBAC Roles Assigned to User:
``` 
Get-AZRoleAssignment | Where {$_.SignInName -like '<User.Name*>'} | FL DisplayName,SignInName,ObjectType,RoleDefinitionName,Scope
```

###### username should be in org specific syntax ie first.last* or admin.name*
###### astericks added so no need to type full UPN
