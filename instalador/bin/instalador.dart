import 'dart:convert';
import "dart:io";
import 'package:archive/archive_io.dart';

void compilar_back() { 
	print("Compilando o back...");
	Process.runSync('go', ['build','-C', Platform.isWindows ? r'..\back' : '../back']);
	var back = File(Platform.isWindows ? r"..\back\biblioteca.exe" : "../back/biblioteca");
	var copia = back.copySync(Platform.isWindows ? r"pallasys\api.exe" : "pallasys/api");
	back.deleteSync();
	print("Terminou de compilar o back...");

}

void criar_pallasys() {
	var pallasys = 'pallasys';
	var data = Platform.isWindows ? r'pallasys\data' : "pallasys/data";
	var lib = Platform.isWindows ? r'pallasys\lib' : "pallasys/lib";
	Directory(pallasys).createSync();
	Directory(data).createSync();
	Directory(lib).createSync();
}

void copiarPasta(String ondeColocar, Directory dir) {
  final separador = Platform.isWindows ? r'\' : "/";
  
  dir.listSync().forEach((elemento)  {
    final stat = elemento.statSync();
    if (stat.type == FileSystemEntityType.file) {
      File(elemento.path).copySync(ondeColocar + separador + elemento.path.split(separador).last);
    } else {
      final novaPasta = Directory(ondeColocar + separador + elemento.path.split(separador).last);
      novaPasta.createSync();
      copiarPasta(novaPasta.path, Directory(elemento.path));
    }
  });
  

}

void compilar_front() async {
	print("Começando a compilar o front...");
	var pasta_instalador = Directory.current.path;
	Directory.current = new Directory(Platform.isWindows ? r'..\front\biblioteca\' : "../front/biblioteca"); 
	Process.runSync('flutter',  ['build',Platform.isWindows ? 'windows' : 'linux'], runInShell: true);
	final pastaRelease = Directory(Platform.isWindows ? r'build\windows\x64\runner\Release\' : "build/linux/x64/release/bundle/");
  final separador = Platform.isWindows ? r'\' : "/";
  copiarPasta(pasta_instalador + separador + 'pallasys', pastaRelease);
	Directory.current = new Directory(pasta_instalador); 
	print("Terminou de compilar o front...");
}

Future<void> criarZip() async {
  print('Começando a fazer o zip...');
  var zip = File(Platform.isWindows ? Directory.current.path +  r"\frontback.zip" : Directory.current.path + "/frontback.zip").openSync(mode: FileMode.write);
  zip.flushSync();

  
  var pacotao = ZipFileEncoder();
  pacotao.create(Platform.isWindows ? Directory.current.path +  r"\frontback.zip" : Directory.current.path + "/frontback.zip");
  zip.closeSync();
  //await pacotao.addFile(File(Platform.isWindows ? "biblioteca.exe" : "biblioteca"));
  await pacotao.addDirectory(Directory('pallasys'));
  pacotao.closeSync();
  print('Terminando de zipar...');

}

Future<void> baixar_banco_de_dados() async{
  print('começando a baixar o banco...');
  final ulr = Platform.isWindows ? "https://github.com/theseus-rs/postgresql-binaries/releases/download/17.2.0/postgresql-17.2.0-x86_64-pc-windows-msvc.tar.gz" : "https://github.com/theseus-rs/postgresql-binaries/releases/download/17.2.0/postgresql-17.2.0-x86_64-unknown-linux-gnu.tar.gz";
  final http = HttpClient();
  final resultado = await (await http.getUrl(Uri.tryParse(ulr)!)).close();
  if (resultado.statusCode != 200) {
      print('Não foi possível baixar o banco!');
      exit(1);
  }
  final arquivo  =  File('bd.tar.gz');
  final dados = List<int>.empty(growable: true);
  for (var element in (await resultado.toList())) {
    for (var b in element) {
      dados.add(b);
    }
  }
  arquivo.writeAsBytesSync(dados, flush: true);
  print('terminou de baixar o banco...');
 
}

void copiar_script() {
  final script = File(Platform.isWindows ? r"..\back\scripts\script.sql" : "../back/scripts/script.sql");
  script.copySync('script.sql');
}

Future<void> main() async {
  criar_pallasys();
	compilar_back();
	compilar_front();
  await criarZip();
  await baixar_banco_de_dados();
  copiar_script();
}
