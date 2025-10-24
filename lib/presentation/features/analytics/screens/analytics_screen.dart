import 'package:brelock/di_injector.dart';
import 'package:brelock/domain/entities/password_analytics.dart';
import 'package:brelock/l10n/generated/app_localizations.dart';
import 'package:brelock/presentation/themes/sizes.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late Future<PasswordAnalytics> _analyticsFuture;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  void _loadAnalytics() {
    print('🔄 Loading analytics for user: ${current_consumer.id}');
    setState(() {
      _analyticsFuture = passwordAnalyticsInteractor.generateAnalytics(current_consumer.id!);
    });
  }

  void _refreshAnalytics() {
    print('🔄 Refreshing analytics...');
    _loadAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n!.passwordAnalytics),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshAnalytics,
            tooltip: 'Обновить аналитику',
          ),
        ],
      ),
      body: FutureBuilder<PasswordAnalytics>(
        future: _analyticsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: Sizes.spacingMd),
                  Text('Анализируем ваши пароли...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            print('❌ Error in analytics future: ${snapshot.error}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: Sizes.spacingMd),
                  Text('Ошибка загрузки аналитики'),
                  SizedBox(height: Sizes.spacingMd),
                  ElevatedButton(
                    onPressed: _refreshAnalytics,
                    child: Text('Попробовать снова'),
                  ),
                ],
              ),
            );
          }

          final analytics = snapshot.data!;
          print('📊 Displaying analytics for ${analytics.totalPasswords} passwords');

          return SingleChildScrollView(
            padding: EdgeInsets.all(Sizes.spacingLg),
            child: Column(
              children: [
                // Общая статистика - теперь по центру
                _buildOverallStats(analytics, colorScheme),
                SizedBox(height: Sizes.spacingLg),

                // Рекомендации
                if (analytics.recommendations.isNotEmpty) ...[
                  _buildRecommendations(analytics, colorScheme),
                  SizedBox(height: Sizes.spacingLg),
                ],

                // Детальная статистика
                _buildDetailedStats(analytics, colorScheme),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverallStats(PasswordAnalytics analytics, ColorScheme colorScheme) {
    return Center(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(Sizes.spacingMd),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Общая безопасность',
                style: TextStyle(
                  fontSize: Sizes.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Sizes.spacingMd),

              if (analytics.totalPasswords == 0) ...[
                Icon(Icons.lock_open, size: 64, color: Colors.grey),
                SizedBox(height: Sizes.spacingMd),
                Text(
                  'Нет данных',
                  style: TextStyle(
                    fontSize: Sizes.fontSizeLarge,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: Sizes.spacingSm),
                Text('Добавьте пароли для анализа'),
              ] else ...[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${analytics.securityScore.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: Sizes.fontSizeHeading,
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(analytics.securityScore),
                      ),
                    ),
                    Text(
                      'Уровень безопасности',
                      style: TextStyle(fontSize: Sizes.fontSizeSmall),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendations(PasswordAnalytics analytics, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(Sizes.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.amber),
                SizedBox(width: Sizes.spacingSm),
                Text(
                  'Рекомендации',
                  style: TextStyle(
                    fontSize: Sizes.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: Sizes.spacingMd),
            ...analytics.recommendations.map((recommendation) => Column(
              children: [
                ListTile(
                  leading: _getRecommendationIcon(recommendation.type),
                  title: Text(recommendation.title),
                  subtitle: Text(recommendation.description),
                  trailing: recommendation.affectedCount > 0
                      ? Chip(
                    label: Text('${recommendation.affectedCount}'),
                    backgroundColor: _getRecommendationColor(recommendation.type).withOpacity(0.2),
                  )
                      : null,
                ),
                if (recommendation != analytics.recommendations.last) Divider(),
              ],
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedStats(PasswordAnalytics analytics, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(Sizes.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics_outlined, color: colorScheme.primary),
                SizedBox(width: Sizes.spacingSm),
                Text(
                  'Детальная статистика',
                  style: TextStyle(
                    fontSize: Sizes.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: Sizes.spacingMd),
            _buildStatItem('Всего паролей', analytics.totalPasswords.toString()),
            if (analytics.totalPasswords > 0) ...[
              _buildStatItem('Надежные пароли', '${analytics.strongPasswords} (${analytics.strongPercentage.toStringAsFixed(1)}%)'),
              _buildStatItem('Средние пароли', '${analytics.mediumPasswords} (${analytics.mediumPercentage.toStringAsFixed(1)}%)'),
              _buildStatItem('Слабые пароли', '${analytics.weakPasswords} (${analytics.weakPercentage.toStringAsFixed(1)}%)'),
              _buildStatItem('Средняя длина', analytics.averagePasswordLength.toStringAsFixed(1)),
              _buildStatItem('Повторяющиеся пароли', analytics.reusedPasswordsCount.toString()),
              _buildStatItem('Устаревшие пароли', analytics.oldPasswordsCount.toString()),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Sizes.spacingSm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Icon _getRecommendationIcon(RecommendationType type) {
    switch (type) {
      case RecommendationType.WEAK_PASSWORD:
        return Icon(Icons.warning, color: Colors.red);
      case RecommendationType.REUSED_PASSWORD:
        return Icon(Icons.content_copy, color: Colors.orange);
      case RecommendationType.OLD_PASSWORD:
        return Icon(Icons.update, color: Colors.blue);
      case RecommendationType.NO_SPECIAL_CHARS:
        return Icon(Icons.password, color: Colors.purple);
      case RecommendationType.SHORT_PASSWORD:
        return Icon(Icons.short_text, color: Colors.amber);
      default:
        return Icon(Icons.info, color: Colors.grey);
    }
  }

  Color _getRecommendationColor(RecommendationType type) {
    switch (type) {
      case RecommendationType.WEAK_PASSWORD:
        return Colors.red;
      case RecommendationType.REUSED_PASSWORD:
        return Colors.orange;
      case RecommendationType.OLD_PASSWORD:
        return Colors.blue;
      case RecommendationType.NO_SPECIAL_CHARS:
        return Colors.purple;
      case RecommendationType.SHORT_PASSWORD:
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}