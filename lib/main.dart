import 'package:flutter/material.dart';
import 'package:javaneiros2018/data.dart';

void main() => runApp(JavaneirosApp());

class JavaneirosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Javaneiros 2018',
      theme: ThemeData(          
        primaryColor: Colors.white,
      ), 
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Image.asset("assets/logo.png", height: 48,)),
        ),
        body: FutureBuilder(
            future: getTalksFromAsset(),
            builder: (context, AsyncSnapshot<List<Talk>> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.hasData) {
                return ListView(
                    children:
                        snapshot.data.map((talk) => TalkTile(talk)).toList());
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}

class TalkTile extends StatelessWidget {
  TalkTile(this.talk);
  final Talk talk;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: _provideThumbnail(talk),
        title: _provideTitle(talk),
        subtitle: _provideSubtitle(talk),
        trailing: Text(talk.startTime),
        contentPadding: EdgeInsets.all(8),
        onTap: () => talk.label == "Palestra"
            ? _createBottomSheet(context, talk)
            : Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text(talk.title))));
  }
}

_provideSubtitle(Talk talk) {
  if(talk.length.isEmpty) {
    return Text("");
  } else {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
    Text("Duração: ${talk.length}"),
    Text("Local: ${talk.place}"),
  ]);
  }  
}

_provideTitle(Talk talk) {
  if (talk.speaker.name.isEmpty) {
    return Text(talk.title);
  } else {
    return Text("${talk.title} - ${talk.speaker.name}");
  }
}

_provideThumbnail(Talk talk) {
  if (talk.speaker.thumbnail.first.isEmpty) {
    return CircleAvatar(
      child: Text(talk.title[0]),
    );
  } else {
    return CircleAvatar(
        backgroundImage:
            AssetImage("speakers/${talk.speaker.thumbnail.first}.jpg"));
  }
}

_createBottomSheet(BuildContext context, Talk talk) {
  return Scaffold.of(context).showBottomSheet((BuildContext context) {
    return ListView(
      children: [
        Row(
            children: talk.speaker.thumbnail
                .map((thumbnail) =>
                    Expanded(child: Image.asset("speakers/${thumbnail}.jpg"),flex: 1))
                .toList()),
        ListTile(leading: Icon(Icons.person), title: Text(talk.speaker.name)),
        ListTile(
          leading: Icon(Icons.folder_shared),
          title: Text(talk.speaker.bio),
          onTap: () => launchBrowser(talk.speaker.bio),
        ),
        ListTile(
          leading: Icon(Icons.link),
          title: Text("Contato"),
          onTap: () => launchBrowser(talk.speaker.contact),
        ),
      ],
    );
  });
}
