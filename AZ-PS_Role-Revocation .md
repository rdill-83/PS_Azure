### Azure RBAC Role Revocation

#### View Existing Azure RBAC Roles Assigned to User:
```
Get-AZRoleAssignment | Where {$_.SignInName -like '<User.Name*>'} | FL DisplayName,SignInName,ObjectType,RoleDefinitionName,Scope
```
#### Remove All Azure RBAC Roles Assigned to User:
``` 
Get-AZRoleAssignment | Where {$_.SignInName -like '<User.Name*>'} | FL DisplayName,SignInName,ObjectType,RoleDefinitionName,Scope
```

###### username should be in whatever syntax your org has ie first.last* or admin.*
###### astericks added so no need to type full UPN
