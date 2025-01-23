import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mentorias_cursos/pages/courses/courses.dart';
import 'package:mentorias_cursos/pages/mentoring/mentoring.dart';
import 'package:html_unescape/html_unescape.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic> _mentories = {};
  Map<String, dynamic> _courses = {}; // Agrega datos para cursos
  bool showMentorias = true; // Controla si se muestran mentorías o cursos

  // Función para obtener mentorías
  _getMentorias() async {
    try {
      http.Response getUserRes = await http.get(
        Uri.parse('https://load-qv4lgu7kga-uc.a.run.app/mentorings/all'),
        headers: {
          'Accept': 'application/json',
          'Content-type': 'application/json',
        },
      );

      if (getUserRes.statusCode == 200) {
        _mentories = jsonDecode(getUserRes.body);
        setState(() {});
      } else {
        print('Error al obtener las mentorías');
      }
    } on SocketException catch (e) {
      print('No hay conexión a internet: ${e.message}');
    } catch (e) {
      print('Ocurrió un error al realizar la solicitud: $e');
    }
  }

  String cleanHtmlText(String htmlText) {
    // Decodifica entidades HTML como &aacute;, &nbsp;, etc.
    final unescape = HtmlUnescape();
    String decodedText = unescape.convert(htmlText);

    // Elimina las etiquetas HTML
    String cleanedText = decodedText.replaceAll(RegExp(r'<[^>]*>'), '');

    // Elimina espacios innecesarios generados por &nbsp;
    cleanedText = cleanedText.replaceAll(RegExp(r'\s+'), ' ').trim();

    return cleanedText;
  }

  // Función para obtener cursos
  _getCursos() async {
    try {
      http.Response getCoursesRes = await http.get(
        Uri.parse('https://load-qv4lgu7kga-uc.a.run.app/Courses/all'),
        headers: {
          'Accept': 'application/json',
          'Content-type': 'application/json',
        },
      );

      if (getCoursesRes.statusCode == 200) {
        _courses = jsonDecode(getCoursesRes.body);
        setState(() {});
      } else {
        print('Error al obtener los cursos');
      }
    } on SocketException catch (e) {
      print('No hay conexión a internet: ${e.message}');
    } catch (e) {
      print('Ocurrió un error al realizar la solicitud: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getCursos();
    _getMentorias(); // Carga mentorías al inicio
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        centerTitle: true,
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.menu, color: Colors.white),
          onSelected: (value) {
            if (value == 'Mentorías') {
              setState(() {
                showMentorias = true;
                _getMentorias();
              });
            } else if (value == 'Cursos') {
              setState(() {
                showMentorias = false;
                _getCursos();
              });
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'Mentorías',
              child: Text('Mentorías'),
            ),
            const PopupMenuItem(
              value: 'Cursos',
              child: Text('Cursos'),
            ),
          ],
        ),
        title: Text(
          showMentorias ? 'Mentorías' : 'Cursos',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            (showMentorias ? _mentories : _courses).isNotEmpty
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: (showMentorias
                            ? _mentories['data']['mentorings']
                            : _courses['data']['items'])
                        .length,
                    itemBuilder: (context, index) {
                      var item = showMentorias
                          ? _mentories['data']['mentorings'][index]
                          : _courses['data']['items'][index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: color,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Column(
                                    children: [
                                      Image.network(
                                        'https://load-qv4lgu7kga-uc.a.run.app/images/${item['image']}',
                                        width: 200,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        item['name'],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    item['description'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                              Colors.green)),
                                  onPressed: () {
                                    showMentorias
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MentoringDetails(
                                                    courses: _courses,
                                                    name: item['name'],
                                                    title: item['title'],
                                                    price: item['characteristics']
                                                        [1]['description'],
                                                    duration:
                                                        item['characteristics']
                                                            [0]['description'],
                                                    description:
                                                        item['description'],
                                                    details: cleanHtmlText(
                                                        item['detail']),
                                                    image:
                                                        'https://load-qv4lgu7kga-uc.a.run.app/images/${item['image']}',
                                                    mentorBio: item['mentor']
                                                        ['biography'],
                                                    mentorEmail: item['mentor']
                                                        ['email'],
                                                    mentorImage:
                                                        'https://load-qv4lgu7kga-uc.a.run.app/images/${item['mentor']['avatar']}',
                                                    mentorName: item['mentor']
                                                        ['name'],
                                                    roleMentor: item['mentor']
                                                        ['role'])))
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => CoursesDetails(
                                                      name: item['name'],
                                                      tax: item['tax']
                                                          .toString(),
                                                      title: item['title'],
                                                      price: item['price']
                                                          .toString(),
                                                      duration: item[
                                                              'characteristics']
                                                          [0]['description'],
                                                      description:
                                                          item['description'],
                                                      image:
                                                          'https://load-qv4lgu7kga-uc.a.run.app/images/${item['image']}',
                                                      mentories: _mentories,
                                                      ranking: item['ranking']
                                                          .toString(),
                                                    )));
                                  },
                                  child: const Text(
                                    'Inscribirse',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  )),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height, // Altura total
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
