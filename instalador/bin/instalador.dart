import 'dart:convert';
import "dart:io";
import 'package:archive/archive_io.dart';

void compilar_back() { 
	print("Compilando o back...");
	Process.runSync('go', ['build','-C', Platform.isWindows ? r'..\back' : '../back']);
	var back = File(Platform.isWindows ? r"..\back\biblioteca.exe" : "../back/biblioteca");
	var copia = back.copySync(Platform.isWindows ? "biblioteca.exe" : "biblioteca");
	back.deleteSync();
	print("Terminou de compilar o back...");

}

void criar_bundle() {
	var bundle = 'bundle';
	var data = Platform.isWindows ? r'bundle\data' : "bundle/data";
	var lib = Platform.isWindows ? r'bundle\lib' : "bundle/lib";
	Directory(bundle).createSync();
	Directory(data).createSync();
	Directory(lib).createSync();
}

void compilar_front() async {
	print("Começando a compilar o front...");
	criar_bundle();
	var pasta_instalador = Directory.current.path;
	Directory.current = new Directory(Platform.isWindows ? r'..\front\biblioteca\' : "../front/biblioteca"); 
	Process.runSync('flutter',  ['build',Platform.isWindows ? 'windows' : 'linux'], runInShell: true);
	var data = Directory(Platform.isWindows ? r'build\windows\x64\runner\Release\data' : "build/linux/x64/release/bundle/data").listSync().whereType<File>();
	var exec = File(Platform.isWindows ? r'build\windows\x64\runner\Release\biblioteca.exe' : "build/linux/x64/release/bundle/biblioteca");
	var separador = Platform.isWindows ? r'\' : '/';
	exec.copySync(
		Platform.isWindows ? 
		pasta_instalador + separador + 'bundle' + separador + 'biblioteca.exe'
		:
		pasta_instalador + separador + 'bundle' + separador + 'biblioteca'
	);	
	data.forEach((f) {
	var nome_arquivo = f.path.split(separador).last;
		f.copySync(pasta_instalador + separador + 'bundle' + separador + 'data' + separador +  nome_arquivo);
	});
	if (Platform.isWindows) {
		var lib = File(r'build\windows\x64\runner\Release\flutter_windows.dll');
		lib.copySync(pasta_instalador + separador + 'bundle' + separador + 'flutter_windows.dll');	
	} else {
		var lib = Directory("build/linux/x64/release/bundle/lib").listSync().whereType<File>();
		lib.forEach((f) {
		var nome_arquivo = f.path.split(separador).last;
		f.copySync(pasta_instalador + separador + 'bundle' + separador + 'lib' + separador +  nome_arquivo);
	});
	}
	
	
	Directory.current = new Directory(pasta_instalador); 


	print("Terminou de compilar o front...");
}

Future<void> criarZip() async {
  print('Começando a fazer o zip...');
  var zip = File(Platform.isWindows ? Directory.current.path +  r"\001.zip" : Directory.current.path + "/001.zip").openSync(mode: FileMode.write);
  zip.flushSync();

  
  var pacotao = ZipFileEncoder();
  pacotao.create(Platform.isWindows ? Directory.current.path +  r"\001.zip" : Directory.current.path + "/001.zip");
  zip.closeSync();
  await pacotao.addFile(File(Platform.isWindows ? "biblioteca.exe" : "biblioteca"));
  await pacotao.addDirectory(Directory('bundle'));
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
	compilar_back();
	compilar_front();
  await criarZip();
  await baixar_banco_de_dados();
  copiar_script();
}
