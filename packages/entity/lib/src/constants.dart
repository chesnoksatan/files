const List<String> codes = [
  '---',
  '--x',
  '-w-',
  '-wx',
  'r--',
  'r-x',
  'rw-',
  'rwx',
];

const List<String> codesHumanReadableString = [
  'None',
  'Executable-only',
  'Write-only',
  'Write and execute',
  'Read-only',
  'Read and execute',
  'Read and write',
  'Read, write and execute',
];

const String suid = "(suid) ";
const String guid = "(guid) ";
const String sticky = "(sticky) ";
const String invalidPermission = "Permission is invalid";
