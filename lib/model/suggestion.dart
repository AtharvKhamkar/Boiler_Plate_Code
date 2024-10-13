class Suggestion {
  String categoryId;
  String category;
  String icon;
  String displayText;
  List<SuggestionDetail> suggestions = [];

  Suggestion({
    required this.categoryId,
    required this.category,
    required this.icon,
    required this.displayText,
    this.suggestions = const [],
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) => Suggestion(
    categoryId: json["categoryId"],
    category: json["category"],
    icon: json["icon"],
    displayText: json["displayText"],
    suggestions: List<SuggestionDetail>.from(json["suggestions"].map((x) => SuggestionDetail.fromJson(x))),
  );

}

class SuggestionDetail {
  String suggestion;
  String query;
  int priority;
  String status;
  String suggestionId;

  SuggestionDetail({
    required this.suggestion,
    required this.query,
    required this.priority,
    required this.status,
    required this.suggestionId,
  });

  factory SuggestionDetail.fromJson(Map<String, dynamic> json) => SuggestionDetail(
    suggestion: json["suggestion"],
    query: json["query"],
    priority: json["priority"],
    status: json["status"],
    suggestionId: json["suggestionId"],
  );
}
