import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MentoriesDisponibles extends StatelessWidget {
  final Map<String, dynamic> mentorings;

  const MentoriesDisponibles({super.key, required this.mentorings});

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Text(
          "Mentorías Disponibles",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        CarouselSlider(
          options: CarouselOptions(
            height: 180, // Altura del carrusel (ajustada para nuevo diseño)
            autoPlay: true, // Reproducción automática
            enlargeCenterPage: true, // Enfocar el elemento central
            enableInfiniteScroll: true,
            autoPlayInterval: const Duration(seconds: 3),
          ),
          items: mentorings['data']['mentorings'].map<Widget>((mentorin) {
            return Builder(
              builder: (BuildContext context) {
                return Card(
                  color: color,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Imagen circular
                        ClipOval(
                          child: Image.network(
                            'https://load-qv4lgu7kga-uc.a.run.app/images/${mentorin['image']}',
                            width: 80, // Tamaño de la imagen circular
                            height: 80,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                            width: 16), // Espaciado entre imagen y texto
                        // Contenedor de texto
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                mentorin['name'], // Nombre del curso
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                mentorin[
                                    'description'], // Descripción del curso
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
