import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/modules/todo/data/models/task_model.dart';
import 'package:todo/modules/todo/presentation/components/card_task.dart';
import 'package:todo/modules/todo/presentation/components/teste_title_number_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        textTheme: GoogleFonts.jetBrainsMonoTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController taskController = TextEditingController();
  List<TaskModel> tasks = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  Future<void> _deleteTask(TaskModel task) async {
    int index = tasks.indexOf(task);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildAnimatedCard(task, animation, index),
      duration: Duration(milliseconds: 300),
    );
    setState(() {
      tasks.remove(task);
    });
    final snackBar = SnackBar(
      content: const Text('Task deleted!'),
      backgroundColor: Color(0xFF1E6F9F),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      // 👈 deixa flutuante
      margin: EdgeInsets.all(16),
      // 👈 espaço das bordas
      shape: RoundedRectangleBorder(
        // 👈 bordas arredondadas
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
      action: SnackBarAction(
        textColor: Colors.white,
        label: 'Undo',
        onPressed: () {
          setState(() {
            tasks.insert(index, task);
            _listKey.currentState?.insertItem(index);
          });
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> handleCheckTask(int index, bool value) async {
    TaskModel task = tasks[index];
    setState(() {
      tasks.remove(task);
    });
    tasks.remove(task);
    TaskModel taskInvert = task.copyWith(done: !value);
    setState(() {
      tasks.insert(index, taskInvert);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF0D0D0D)),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 250,
              color: Color(0xFF0D0D0D),
              child: Center(child: SvgPicture.asset('assets/logos/Logo.svg')),
            ),
            Container(
              color: Color(0xFF1A1A1A),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Transform.translate(
                  offset: Offset(0, -35), // sobe 10 pixels
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: TextField(
                            controller: taskController,
                            style: TextStyle(color: Color(0xFFAAAAAA)),
                            cursorColor: Color(0xFF1E6F9F),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 20,
                              ),
                              filled: true,
                              fillColor: Color(0xFF262626),
                              // fundo
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide.none, // remove borda padrão
                              ),
                              hintText: 'Adicione uma nova tarefa',
                              hintStyle: TextStyle(
                                color: Color(0xFFAAAAAA), // cor do placeholder
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8), // espaço entre input e botão

                      SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (taskController.text.isEmpty) {
                                return;
                              }
                              TaskModel newTask = TaskModel(
                                uuid: DateTime.now().millisecondsSinceEpoch
                                    .toString(),
                                description: taskController.text,
                                done: false,
                              );
                              taskController.clear();
                              tasks.insert(0, newTask);
                              _listKey.currentState?.insertItem(0);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1E6F9F),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              Text(
                                'Criar',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(width: 8),
                              // espaçamento entre texto e ícone
                              Icon(
                                Icons.add_circle_outline,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Color(0xFF1A1A1A),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    TesteTitleNumberIndicator(
                      title: 'Tarefas criadas',
                      cor: Color(0xFF4EA8DE),
                      quantidade: tasks.length,
                    ),
                    Spacer(),
                    TesteTitleNumberIndicator(
                      title: 'Concluidas',
                      cor: Color(0xFF8284FA),
                      quantidade: tasks.where((task) => task.done).length,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Color(0xFF1A1A1A),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: tasks.isNotEmpty
                      ? AnimatedList(
                          key: _listKey,
                          initialItemCount: tasks.length,
                          itemBuilder: (context, index, animation) {
                            return _buildAnimatedCard(
                              tasks[index],
                              animation,
                              index,
                            );
                          },
                        )
                      : Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.assignment_outlined,
                                size: 100,
                                color: Color(0xFF333333),
                              ),
                              Text(
                                "Você ainda não tem tarefas cadastradas",
                                style: TextStyle(color: Color(0xFF808080)),
                              ),
                              Text(
                                "Crie tarefas e organize seus itens a fazer",
                                style: TextStyle(color: Color(0xFF333333)),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCard(
    TaskModel task,
    Animation<double> animation,
    int index,
  ) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: CardTask(
          task: task,
          deleteTask: _deleteTask,
          handleCheckTask: handleCheckTask,
          index: index,
        ),
      ),
    );
  }
}
