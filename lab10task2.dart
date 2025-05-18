import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() => runApp(SocialApp());

class SocialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UploadScreen(),
    );
  }
}

class Post {
  String title;
  String description;
  File? image;

  Post({required this.title, required this.description, this.image});
}

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  File? selectedImage;
  final List<Post> posts = [];

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  void uploadPost() {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty || selectedImage == null) return;
    setState(() {
      posts.add(Post(
        title: titleController.text,
        description: descriptionController.text,
        image: selectedImage,
      ));
      titleController.clear();
      descriptionController.clear();
      selectedImage = null;
    });
  }

  void deletePost(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Post"),
        content: Text("Are you sure you want to delete this post?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("No")),
          TextButton(
              onPressed: () {
                setState(() {
                  posts.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: Text("Yes"))
        ],
      ),
    );
  }

  void updatePost(int index) {
    final post = posts[index];
    titleController.text = post.title;
    descriptionController.text = post.description;
    selectedImage = post.image;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Post"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
            TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
            ElevatedButton(onPressed: pickImage, child: Text("Change Image")),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel")),
          TextButton(
              onPressed: () {
                setState(() {
                  post.title = titleController.text;
                  post.description = descriptionController.text;
                  post.image = selectedImage;
                });
                titleController.clear();
                descriptionController.clear();
                selectedImage = null;
                Navigator.pop(context);
              },
              child: Text("Update"))
        ],
      ),
    );
  }

  void downloadImage(File image) {
    // Simulated download process
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image downloaded successfully!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Social Media App")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(controller: titleController, decoration: InputDecoration(labelText: "Post Title")),
              TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Post Description")),
              SizedBox(height: 10),
              ElevatedButton(onPressed: pickImage, child: Text("Pick Image")),
              if (selectedImage != null)
                Image.file(selectedImage!, height: 150),
              SizedBox(height: 10),
              ElevatedButton(onPressed: uploadPost, child: Text("Upload Post")),
              Divider(),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Card(
                    child: ListTile(
                      title: Text(post.title),
                      subtitle: Text(post.description),
                      leading: GestureDetector(
                        onLongPress: () => downloadImage(post.image!),
                        child: Image.file(post.image!, width: 50, height: 50, fit: BoxFit.cover),
                      ),
                      trailing: Wrap(
                        spacing: 12,
                        children: [
                          IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => updatePost(index)),
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => deletePost(index))
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
