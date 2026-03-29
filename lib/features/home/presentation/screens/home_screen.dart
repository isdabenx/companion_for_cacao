import 'dart:async';

import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:companion_for_cacao/shared/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final completedFeatures = <String>[
      '🏠 Menú Principal: Accés ràpid a totes les funcionalitats.',
      '🗂 Base de Dades de Rajoles: Catàleg complet de rajoles.',
      '🔍 Filtrat de Rajoles: Cerca i filtra per diversos criteris.',
      '🎲 Dashboard de Partida: Resum, preparació i rajoles en joc (joc base i Chocolatl).',
      '📖 Manuals Integrats: Consulta les regles del joc.',
      '📊 UI Adaptativa: Disseny optimitzat per a diferents pantalles.',
      '🔄 Auto-Updater: Detecció automàtica de noves versions.',
    ];

    final pendingFeatures = <String>[
      '🕒 Temporitzador de Torns: Controla la durada de cada torn.',
      '🏆 Càlcul de Puntuació Final: Calculadora automàtica de punts.',
      '⚙️ Configuració Personalitzada: Ajusta l\'experiència de joc.',
      '🌐 Suport Multiidioma: Interfície en diversos idiomes.',
      '🚀 Expansió Diamante: Suport complet per a l\'expansió Diamante.',
    ];

    return UpgradeAlert(
      child: CustomScaffoldWidget(
        title: 'Home',
        body: ContainerFullStyleWidget(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Companion for',
                    style: AppTextStyles.titleTextStyle.copyWith(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Center(child: Image.asset(Assets.cacaoTile)),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Companion for Cacao és una aplicació mòbil desenvolupada amb Flutter dissenyada per a ajudar els jugadors del joc de taula Cacao i les seves expansions. '
                    'L\'objectiu és proporcionar eines digitals que millorin l\'experiència de joc facilitant el seguiment de puntuacions, la consulta de regles i la gestió de partides.',
                  ),
                ),
                const SizedBox(height: 20),
                const HeaderWidget(text: 'Funcionalitats Completades'),
                for (final String feature in completedFeatures)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(feature),
                  ),
                const SizedBox(height: 20),
                const HeaderWidget(text: 'Funcionalitats Pendents'),
                for (final String feature in pendingFeatures)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(feature),
                  ),
                const SizedBox(height: 20),
                const HeaderWidget(text: 'Contacta amb mi'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Per a suggeriments, millores, errors o qualsevol altra consulta, '
                    'pots visitar el nostre repositori de GitHub. L\'aplicació és de codi obert '
                    'i sempre busquem col·laboradors per ajudar a millorar-la.',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Visita el nostre repositori de GitHub:',

                    style: AppTextStyles.markdownBody.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: GestureDetector(
                    onTap: () {
                      final url = Uri.parse(
                        'https://github.com/isdabenx/companion_for_cacao',
                      );
                      unawaited(launchUrl(url));
                    },
                    child: Text(
                      'https://github.com/isdabenx/companion_for_cacao',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'A GitHub, pots obrir "issues" per a informar d\'errors, suggerir noves funcionalitats '
                    'o fins i tot enviar "pull requests" amb les teves pròpies contribucions. '
                    'Ens esforcem per millorar constantment l\'aplicació i agraïm qualsevol ajuda!',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
