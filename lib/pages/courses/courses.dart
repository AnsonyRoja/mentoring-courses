import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mentorias_cursos/pages/courses/mentories_enable.dart';

class CoursesDetails extends StatefulWidget {
  final String title;
  final String name;
  final String image;
  final String tax;
  final String price;
  final String duration;
  final String description;
  final String ranking;
  final Map<String, dynamic> mentories;

  const CoursesDetails({
    super.key,
    required this.name,
    required this.tax,
    required this.title,
    required this.price,
    required this.duration,
    required this.description,
    required this.image,
    required this.mentories,
    required this.ranking,
  });

  @override
  State<CoursesDetails> createState() => _CoursesDetailsState();
}

class _CoursesDetailsState extends State<CoursesDetails> {
  bool showFullText = false;

  double _totalAmount() {
    double totalTax =
        (double.parse(widget.price) * double.parse(widget.tax) / 100);
    double totalAmount = double.parse(widget.price) - totalTax;
    return totalAmount;
  }

  @override
  void initState() {
    print('Valor de curso ${widget.mentories}');
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
          "Detalles del Curso",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Imagen
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
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
              ),
              const SizedBox(height: 10),

              // Descripción
              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
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
                  //USD 8.99$
                  Text(
                    "USD ${_totalAmount().toStringAsFixed(2)}\$",
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
              const SizedBox(height: 20),

              // Ranking
              Row(
                children: [
                  const Text(
                    "Calificación: ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RatingBarIndicator(
                    rating: double.parse(widget.ranking),
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    unratedColor: Colors.amber.withAlpha(50),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "(${widget.ranking}/5)",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Espacio para agregar más detalles o botones
              ElevatedButton(
                onPressed: () {
                  // Acción del botón
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
                child: const Text(
                  "Inscribirme",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),

              MentoriesDisponibles(mentorings: widget.mentories),
            ],
          ),
        ),
      ),
    );
  }
}
