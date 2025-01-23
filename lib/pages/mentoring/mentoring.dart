import 'package:flutter/material.dart';
import 'package:mentorias_cursos/pages/mentoring/cursos_enable.dart';

class MentoringDetails extends StatefulWidget {
  final String title;
  final String name;
  final String image;
  final String price;
  final String duration;
  final String description;
  final String details;
  final String mentorImage;
  final String mentorName;
  final String mentorBio;
  final String mentorEmail;
  final String roleMentor;
  final Map<String, dynamic> courses;

  const MentoringDetails({
    super.key,
    required this.name,
    required this.title,
    required this.price,
    required this.duration,
    required this.description,
    required this.details,
    required this.image,
    required this.mentorBio,
    required this.mentorEmail,
    required this.mentorImage,
    required this.mentorName,
    required this.roleMentor,
    required this.courses,
  });

  @override
  State<MentoringDetails> createState() => _MentoringDetailsState();
}

class _MentoringDetailsState extends State<MentoringDetails> {
  bool showFullText = false;

  @override
  void initState() {
    print('valor de curso ${widget.courses}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        backgroundColor: color,
        title: const Text(
          "Detalles de la Mentoria",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título y Descripción breve
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),

              // Imagen de la mentoria
              Image.network(
                widget.image,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),

              // Detalles de la Mentoria
              const Text(
                "Detalles",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Detalles con truncado y botón de "ver más"
              StatefulBuilder(
                builder: (context, setStates) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        showFullText
                            ? widget.details
                            : '${widget.details.substring(0, 100)}...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      if (!showFullText || showFullText)
                        GestureDetector(
                          onTap: () {
                            if (!showFullText) {
                              setStates(() {
                                showFullText = true;
                              });
                            } else {
                              setStates(() {
                                showFullText = false;
                              });
                            }
                          },
                          child: showFullText != true
                              ? const Text(
                                  '... Ver más',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : const Text(
                                  '...Ver menos',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              // Precio y duración
              Row(
                children: [
                  const Text(
                    "Precio: ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.price,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Duración: ${widget.duration}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Mentor Info
              Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      widget.mentorImage,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.mentorName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.roleMentor,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.mentorBio,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 20),
              CursosDisponibles(courses: widget.courses)
            ],
          ),
        ),
      ),
    );
  }
}
