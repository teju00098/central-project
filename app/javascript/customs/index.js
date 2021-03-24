window.clickedImportMaster = () => {
  var xhttp = new XMLHttpRequest();
  xhttp.open("GET", "/masters/prepare_import");
  xhttp.setRequestHeader('Content-Type', 'text/javascript');
  xhttp.send();
  return false
}