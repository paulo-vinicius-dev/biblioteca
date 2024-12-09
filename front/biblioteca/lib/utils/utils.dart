void capitalize(String input) {
  var capitalize = input.split(' ').map((w) => w[0] + w.substring(1));

  print(capitalize);
}
