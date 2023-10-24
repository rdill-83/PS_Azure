### Check AZ VM Recovery Services Backup Job Status:

#### Check AZ Recovery Services Backup Job - Basic CMDLET:
```
Get-AZRecoveryServicesBackupJob -Vault (Get-AZRecoveryServicesVault).ID
```

#### Check AZ Recovery Services Backup Job - Pertinent Info:
```
Get-AZRecoveryServicesBackupJob -Vault (Get-AZRecoveryServicesVault).ID | FT JobID,WorkloadName,Operation,Status,EndTime
```
