class BookModel {
  BookModel({
    required this.author,
    required this.cover,
    required this.id,
    required this.rating,
    required this.title,
  });

  var author;
  var cover;
  var id;
  var rating;
  var title;

  factory BookModel.fromJson(Map<String, dynamic> json) => BookModel(
    author: json["author"] == null ? "null" : json["author"],
    cover: json["cover"] == null ? "null" : json["cover"],
    id: json["id"] == null ? "null" : json["id"],
    rating: json["rating"] == null ? "null" : json["rating"],
    title: json["title"] == null ? "null" : json["title"],
  );

  Map<String, dynamic> toJson() => {
    "author": author == null ? null : author,
    "cover": cover == null ? null : cover,
    "id": id == null ? null : id,
    "rating": rating == null ? null : rating,
    "title": title == null ? null : title,
  };
}
