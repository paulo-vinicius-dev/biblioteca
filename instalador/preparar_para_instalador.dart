import "dart:io";

void compilar_back() { 
	print("Compilando o back...");
	Process.runSync('go', ['build','-C', '../back']);
	var back = File(Platform.isWindows ? "../back/biblioteca.exe" : "../back/biblioteca");
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
	Directory.current = new Directory(Platform.isWindows ? r'..\front\biblioteca' : "../front/biblioteca"); 
	Process.runSync('flutter', ['build','linux']);
	var data = Directory(Platform.isWindows ? r'build\windows\x64\release\bundle\data' : "build/linux/x64/release/bundle/data").listSync().whereType<File>();
	var lib = Directory(Platform.isWindows ? r'build\windows\x64\release\bundle\lib' : "build/linux/x64/release/bundle/lib").listSync().whereType<File>();
	var exec = File(Platform.isWindows ? r'build\windows\x64\release\bundle\biblioteca.exe' : "build/linux/x64/release/bundle/biblioteca");
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
	lib.forEach((f) {
	var nome_arquivo = f.path.split(separador).last;
		f.copySync(pasta_instalador + separador + 'bundle' + separador + 'lib' + separador +  nome_arquivo);
	});
	


	print("Terminou de compilar o front...");
}

void main() async {
	compilar_back();
	compilar_front();
}
