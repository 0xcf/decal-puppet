class decal_common::nfs {
  package { 'nfs-common':; }

  # Create directories to mount NFS shares on
  # Directory permissions are set by NFS share when mounted
  # Use exec instead of file so that permissions are not managed
  exec {
    '/bin/mkdir -p /opt/lab7/read-only':
      creates => '/opt/lab7/read-only';
    '/bin/mkdir -p /opt/lab7/read-write':
      creates => '/opt/lab7/read-write';
  }
}
