import 'package:clean_arch_and_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/presentation/widgets/loading_widget.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/presentation/widgets/message.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/presentation/widgets/trivia_result.dart';
import 'package:clean_arch_and_tdd/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class NumberTriviaPage extends StatefulWidget {
  NumberTriviaPage({Key? key}) : super(key: key);

  @override
  State<NumberTriviaPage> createState() => _NumberTriviaPageState();
}

class _NumberTriviaPageState extends State<NumberTriviaPage> {
  final TextEditingController numberC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Number Trivia',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .4,
                  child: Center(
                    child: state is Empty
                        ? const Message(message: 'Start Searching')
                        : state is Error
                            ? Message(message: state.message)
                            : state is Loaded
                                ? TriviaResult(trivia: state.trivia)
                                : const LoadingWidget(),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: numberC,
                    onSubmitted: (v) => _getConcreteNT(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter A Number'),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: _getConcreteNT,
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder()),
                          child: const Text('Search')),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: _getRandomNT,
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder()),
                          child: const Text('Random')),
                    ),
                    const SizedBox(width: 16),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _getConcreteNT() {
    if (numberC.text.trim().isNotEmpty) {
      context
          .read<NumberTriviaBloc>()
          .add(GetConcreteNumberTriviaEvent(numberC.text.trim()));
      numberC.clear();
    }
  }

  void _getRandomNT() =>
      context.read<NumberTriviaBloc>().add(GetRandomNumberTriviaEvent());
}
