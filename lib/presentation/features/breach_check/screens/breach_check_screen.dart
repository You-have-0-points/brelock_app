import 'package:brelock/di_injector.dart';
import 'package:brelock/domain/entities/breach_check_result.dart';
import 'package:brelock/l10n/generated/app_localizations.dart';
import 'package:brelock/presentation/themes/sizes.dart';
import 'package:flutter/material.dart';

class BreachCheckScreen extends StatefulWidget {
  const BreachCheckScreen({super.key});

  @override
  State<BreachCheckScreen> createState() => _BreachCheckScreenState();
}

class _BreachCheckScreenState extends State<BreachCheckScreen> {
  late Future<BreachCheckResult> _breachCheckFuture;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _breachCheckFuture = _performBreachCheck();
  }

  Future<BreachCheckResult> _performBreachCheck() async {
    final result = await breachCheckInteractor.checkAllPasswords(current_consumer.id!);
    setState(() {
      _isChecking = false;
    });
    return result;
  }

  void _recheckBreaches() {
    setState(() {
      _isChecking = true;
      _breachCheckFuture = _performBreachCheck();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n!.breachCheck),
        centerTitle: true,
      ),
      body: FutureBuilder<BreachCheckResult>(
        future: _breachCheckFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState(l10n);
          }

          if (snapshot.hasError) {
            return _buildErrorState(l10n, colorScheme, snapshot.error.toString());
          }

          final result = snapshot.data!;
          return _buildResultState(l10n, colorScheme, result);
        },
      ),
    );
  }

  Widget _buildLoadingState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: Sizes.spacingLg),
          Text(
            l10n.checkingForBreaches,
            style: TextStyle(fontSize: Sizes.fontSizeLarge),
          ),
          SizedBox(height: Sizes.spacingMd),
          Text(
            l10n.breachCheckDescription,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(AppLocalizations l10n, ColorScheme colorScheme, String error) {
    return Padding(
      padding: EdgeInsets.all(Sizes.spacingLg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: colorScheme.error,
          ),
          SizedBox(height: Sizes.spacingLg),
          Text(
            l10n.breachCheckError,
            style: TextStyle(
              fontSize: Sizes.fontSizeLarge,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Sizes.spacingMd),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: Sizes.spacingLg),
          ElevatedButton(
            onPressed: _recheckBreaches,
            child: Text(l10n.tryAgain),
          ),
        ],
      ),
    );
  }

  Widget _buildResultState(AppLocalizations l10n, ColorScheme colorScheme, BreachCheckResult result) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(Sizes.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок с результатом
          /*Card(
            color: result.isSafe ? Colors.green[50] : Colors.orange[50],
            child: Padding(
              padding: EdgeInsets.all(Sizes.spacingLg),
              child: Column(
                children: [
                  Icon(
                    result.isSafe ? Icons.security : Icons.warning_amber,
                    size: 64,
                    color: result.isSafe ? Colors.green : Colors.orange,
                  ),
                  SizedBox(height: Sizes.spacingMd),
                  Text(
                    result.isSafe ? l10n.noBreachesFound : l10n.breachesFound,
                    style: TextStyle(
                      fontSize: Sizes.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                      color: result.isSafe ? Colors.green : Colors.orange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Sizes.spacingSm),
                  Text(
                    l10n.checkedPasswordsCount(result.totalPasswords.toString()),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ), */

          SizedBox(height: Sizes.spacingLg),

          // Детальная информация
          if (result.isSafe) _buildSafeState(l10n, colorScheme),
          if (!result.isSafe) _buildCompromisedState(l10n, colorScheme, result),

          SizedBox(height: Sizes.spacingLg),

          // Кнопка повторной проверки
          Center(
            child: OutlinedButton(
              onPressed: _recheckBreaches,
              child: Text(l10n.recheckBreaches),
            ),
          ),

          SizedBox(height: Sizes.spacingLg),

          // Информация о проверке
          Card(
            child: Padding(
              padding: EdgeInsets.all(Sizes.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.howItWorks,
                    style: TextStyle(
                      fontSize: Sizes.fontSizeMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Sizes.spacingSm),
                  Text(
                    l10n.breachCheckInfo,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: Sizes.spacingSm),
                  Text(
                    l10n.lastChecked(result.checkedAt.toString()),
                    style: TextStyle(
                      fontSize: Sizes.fontSizeSmall,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafeState(AppLocalizations l10n, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(Sizes.spacingLg),
        child: Column(
          children: [
            Icon(
              Icons.verified_user,
              size: 48,
              color: Colors.green,
            ),
            SizedBox(height: Sizes.spacingMd),
            Text(
              l10n.allPasswordsSecure,
              style: TextStyle(
                fontSize: Sizes.fontSizeMedium,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Sizes.spacingSm),
            Text(
              l10n.noCompromisedPasswords,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompromisedState(AppLocalizations l10n, ColorScheme colorScheme, BreachCheckResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.compromisedPasswords(result.compromisedCount.toString()),
          style: TextStyle(
            fontSize: Sizes.fontSizeLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: Sizes.spacingMd),
        ...result.compromisedPasswords.map((compromised) => Card(
          color: Colors.orange[50],
          child: Padding(
            padding: EdgeInsets.all(Sizes.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange, size: 20),
                    SizedBox(width: Sizes.spacingSm),
                    Text(
                      compromised.serviceName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Sizes.spacingSm),
                Text('${l10n.login}: ${compromised.login}'),
                SizedBox(height: Sizes.spacingXs),
                Text('${l10n.breachSource}: ${compromised.breachSource}'),
                SizedBox(height: Sizes.spacingXs),
                Text('${l10n.breachDate}: ${_formatDate(compromised.breachDate)}'),
              ],
            ),
          ),
        )).toList(),
        SizedBox(height: Sizes.spacingMd),
        Card(
          color: Colors.blue[50],
          child: Padding(
            padding: EdgeInsets.all(Sizes.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.whatToDo,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                SizedBox(height: Sizes.spacingSm),
                Text(l10n.breachActionAdvice),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}