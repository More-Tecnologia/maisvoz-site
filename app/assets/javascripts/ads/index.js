function copyToClipboard(value) {
  navigator.clipboard.writeText(value);
  Swal.fire(
    '',
    '',
    'success'
  )
}
