import 'package:flutter/material.dart';
import 'package:imposter_syndrome_game/app_configs.dart';
import 'package:imposter_syndrome_game/data/game_data.dart';
import 'package:imposter_syndrome_game/widgets/show_dialog_box.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../screens/off_play.dart';
import '../widgets/popup_dropdown_list.dart';

class GameDialogs {
  static void showGameEndDialog(
    BuildContext context,
    bool imposterWon,
    String answer,
    String imposterPlayerName,
  ) {
    Future.delayed(AppConfigs.popupDisplayDelay, () {
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: imposterWon
                    ? const Color.fromARGB(255, 171, 114, 95)
                    : const Color.fromARGB(255, 0, 255, 4),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "The Word: $answer",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    imposterWon
                        ? '$imposterPlayerName Fooled The Lobby'
                        : '${AppConfigs.teamNameString} Won Against $imposterPlayerName',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop(); // Go back to main screen
                    },
                    child: const Text('Play Again'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  static void showNextRoundDialog(BuildContext context, VoidCallback startTimer,
      Function(GameProvider) postElimination) {
    final gameProvider = context.read<GameProvider>();
    Future.delayed(AppConfigs.popupDisplayDelay, () {
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Imposter is still among us'),
            content: const Text('Proceed to the next round.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  startTimer();
                  postElimination(gameProvider);
                },
                child: const Text('Start Next Round'),
              ),
            ],
          );
        },
      );
    });
  }

  static void showGameStartDialog(
    BuildContext context,
    String category,
    int totalPlayers,
    String roundLength,
    VoidCallback startTimer,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ShowDialogBox(
            showDialogChild: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Who\'s The ${AppConfigs.imposterString}?',
              style: AppConfigs.popUpDisplayTitleTS,
            ),
            const SizedBox(height: 10),
            Text(
              'Category: $category\nRound Length: $roundLength\nTotal Players: $totalPlayers',
              style: AppConfigs.popUpDisplayMenuTS,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                startTimer();
              },
              child: const Text(
                'Let\'s Begin the Game!',
                style: AppConfigs.popUpDisplayButtonTS,
              ),
            ),
          ],
        ));
      },
    );
  }

  static void showAddCustomDataDialog(
      BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController dataController = TextEditingController();
        final GlobalKey<FormState> formKey = GlobalKey<FormState>();
        String selectedCategory = gameProvider.selectedCategory;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return ShowDialogBox(
              showDialogChild: Container(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Add Custom Data',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: PopupDropdownList<String>(
                              value: selectedCategory,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedCategory = newValue;
                                  });
                                }
                              },
                              items: GameData.getCategories()
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: AppConfigs.popUpDisplayMenuTS,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add_box,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  final TextEditingController
                                      newCategoryController =
                                      TextEditingController();
                                  final TextEditingController
                                      newCardDataController =
                                      TextEditingController();
                                  final GlobalKey<FormState> newFormKey =
                                      GlobalKey<FormState>();

                                  return ShowDialogBox(
                                    showDialogChild: Container(
                                      padding: const EdgeInsets.all(20),
                                      child: Form(
                                        key: newFormKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              'Add New Category & Card',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 101, 155, 198),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            TextFormField(
                                              controller: newCategoryController,
                                              decoration: const InputDecoration(
                                                labelText: 'New Category',
                                                labelStyle: AppConfigs
                                                    .popUpDisplayButtonTS,
                                                border: OutlineInputBorder(),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.trim().isEmpty) {
                                                  return 'Please Enter New Category';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 10),
                                            TextFormField(
                                              controller: newCardDataController,
                                              decoration: const InputDecoration(
                                                labelText: 'Card Data',
                                                labelStyle: AppConfigs
                                                    .popUpDisplayButtonTS,
                                                border: OutlineInputBorder(),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.trim().isEmpty) {
                                                  return 'Please Enter Card Data';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    showAddCustomDataDialog(
                                                        context, gameProvider);
                                                  },
                                                  child: const Text(
                                                    'Cancel',
                                                    style: AppConfigs
                                                        .popUpDisplayButtonTS,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    if (newFormKey.currentState!
                                                        .validate()) {
                                                      String newCategory =
                                                          newCategoryController
                                                              .text;
                                                      String newCardData =
                                                          newCardDataController
                                                              .text;
                                                      GameData.addCategory(
                                                          newCategory);
                                                      GameData.addData(
                                                          newCategory,
                                                          newCardData);
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  },
                                                  child: const Text('Submit'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: dataController,
                        decoration: const InputDecoration(
                          labelText: 'Custom Data',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please Enter Custom Data';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Cancel',
                              style: AppConfigs.popUpDisplayButtonTS,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                String customData = dataController.text;
                                GameData.addData(selectedCategory, customData);
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static void showOfflinePlayDialog(
      BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Set these defaults in app configs
        int selectedPlayers = gameProvider.lobbySize;
        String selectedCategory = gameProvider.selectedCategory;
        String selectedRoundLength = '30 seconds';

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return ShowDialogBox(
              showDialogChild: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Play Settings",
                    style: AppConfigs.popUpDisplayTitleTS,
                  ),
                  PopupDropdownList<int>(
                    value: selectedPlayers,
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedPlayers = newValue;
                        });
                      }
                    },
                    items: GameData.getPlayerLobbySize()
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          '$value Players',
                          style: AppConfigs.popUpDisplayMenuTS,
                        ),
                      );
                    }).toList(),
                  ),
                  PopupDropdownList<String>(
                    value: selectedCategory,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      }
                    },
                    items: GameData.getCategories()
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: AppConfigs.popUpDisplayMenuTS,
                        ),
                      );
                    }).toList(),
                  ),
                  PopupDropdownList<String>(
                    value: selectedRoundLength,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedRoundLength = newValue;
                        });
                      }
                    },
                    items: GameData.getRoundLengthOptions()
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: AppConfigs.popUpDisplayMenuTS,
                        ),
                      );
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: AppConfigs.popUpDisplayButtonTS,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => OffPlay(
                                numberOfPlayers: selectedPlayers,
                                category: selectedCategory,
                                roundLength: selectedRoundLength,
                                gameProvider: gameProvider,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Play',
                          style: AppConfigs.popUpDisplayButtonTS,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Future<String?> showUserNameDialog(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 255, 255, 0.8),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Enter Player Name',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Player Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please Enter Your Player Name';
                      } else if (value.length >= 11) {
                        return "Player Name Should < 11 letters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            // Handle the valid username
                            String username = controller.text;
                            Navigator.of(context).pop(username);
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showAboutGameDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppConfigs.gameName,
      applicationVersion: '1.0.0',
      // applicationIcon: const ImageIcon(
      //   AssetImage('assets/icon/icon.png'),
      //   size: 48.0, // You can adjust the size as needed
      // ),
      children: [
        const Text(AppConfigs.aboutGame),
      ],
    );
  }

  static void showHowToPlayDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ShowDialogBox(
            showDialogChild: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'How To Play?',
                  style: AppConfigs.popUpDisplayTitleTS,
                ),
                const SizedBox(height: 10),
                const Text(
                  '1. Get a group of friends (Hardest Part!).\n2. Press Play, Choose the number of players, category. \n3. Each player privately selects a card, sees what is written and clicks again to fold it back. \n4. All players will have same thing written except one (Imposter). \n5. Each round all player discuss to vote out someone and that player\'s card is selected. \n6. Game continues either till imposter is eliminated or only 2 players (including imposter is remaining)',
                  style: AppConfigs.popUpDisplayButtonTS,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Close',
                    style: AppConfigs.popUpDisplayButtonTS,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
