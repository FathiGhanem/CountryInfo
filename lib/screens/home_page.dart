import 'package:country_info/screens/flag_page.dart';
import 'package:country_info/services/country_servies.dart';
import 'package:flutter/material.dart';
import 'package:country_info/models/country_model.dart';

class CountryPage extends StatefulWidget {
  const CountryPage({super.key});

  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  List<String> names = ["Select Country", "Jordan", "Canada", "Australia"];
  String selected = "Select Country";
  bool start = false;
  double sliderValue = 250;
  Future<CountryModel>? _future;
  Future<List<CountryModel>>? _futureForSorting;
  bool showPop = true;
  bool showArea = true;
  bool changeColor = false;
  bool sort = false;
  bool _isDetailOpen = false;

  void onSort() {
    if (start) {
      setState(() {
        _futureForSorting = CountryServies().fetchCountrys(names);
        sort = true;
      });
    }
  }

  void onCountryChanged(String value) {
    setState(() {
      selected = value;
      start = selected != "Select Country";
      if (start) {
        _future = CountryServies().fetchCountry(selected);
      } else {
        _future = null;
      }
    });
  }

  void restApp() {
    setState(() {
      if (start) {
        selected = "Select Country";
        start = false;
        sliderValue = 400;
        _future = null;
        showPop = true;
        showArea = true;
        changeColor = false;
        sort = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  "Country Options",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            ListTile(
              title: Text("Red Text Color"),
              trailing: Checkbox(
                value: changeColor,
                onChanged: (value) {
                  setState(() {
                    changeColor = value!;
                  });
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.sort),
              title: Text("Sort By Density"),
              onTap: () {
                onSort();
              },
            ),
            ListTile(
              leading: Icon(Icons.restart_alt),
              title: Text("Rest App"),
              onTap: () {
                restApp();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(title: Text("Country Info")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                color: start ? Colors.grey : Colors.white,
                child: DropdownButton<String>(
                  dropdownColor: start ? Colors.grey : Colors.white,
                  style: TextStyle(
                    color: changeColor ? Colors.red : Colors.black,
                  ),
                  value: selected,
                  items: names.map((country) {
                    return DropdownMenuItem(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),
                  onChanged: (value) {
                    onCountryChanged(value!);
                  },
                ),
              ),
              if (start)
                Center(
                  child: FutureBuilder<CountryModel>(
                    future: _future,
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snap.hasError) {
                        return Text('Error: ${snap.error}');
                      }
                      if (!snap.hasData) {
                        return Text('No data');
                      }
                      final c = snap.data!;
                      return Column(
                        children: [
                          Text(
                            c.name,
                            style: TextStyle(
                              color: changeColor ? Colors.red : Colors.black,
                            ),
                          ),
                          Image.network(c.flag, width: sliderValue),
                          Slider(
                            value: sliderValue,
                            min: 50,
                            max: 1000,
                            onChanged: (newValue) async {
                              final wasSmall = sliderValue <= 400;
                              final nowLarge = newValue > 400;

                              setState(() {
                                sliderValue = newValue;
                              });

                              if (wasSmall && nowLarge && !_isDetailOpen) {
                                _isDetailOpen = true;

                                final returnedValue = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FlagPage(
                                      flag: c.flag,
                                      sliderValue: sliderValue.toInt(),
                                    ),
                                  ),
                                );

                                if (returnedValue != null) {
                                  setState(
                                    () =>
                                        sliderValue = returnedValue.toDouble(),
                                  );
                                }

                                _isDetailOpen = false;
                              }
                            },
                          ),

                          if (showPop)
                            Text(
                              "Population:${c.pop}",
                              style: TextStyle(
                                color: changeColor ? Colors.red : Colors.black,
                              ),
                            ),
                          ListTile(
                            title: Text(
                              "Show Population",
                              style: TextStyle(
                                color: changeColor ? Colors.red : Colors.black,
                              ),
                            ),
                            trailing: Checkbox(
                              value: showPop,
                              onChanged: (value) {
                                setState(() {
                                  showPop = value!;
                                });
                              },
                            ),
                          ),
                          if (showArea)
                            Text(
                              "Area:${c.area}",
                              style: TextStyle(
                                color: changeColor ? Colors.red : Colors.black,
                              ),
                            ),
                          ListTile(
                            title: Text(
                              "Show Area",
                              style: TextStyle(
                                color: changeColor ? Colors.red : Colors.black,
                              ),
                            ),
                            trailing: Checkbox(
                              value: showArea,
                              onChanged: (value) {
                                setState(() {
                                  showArea = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              if (sort)
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text("Density"),
                        Expanded(
                          child: FutureBuilder(
                            future: _futureForSorting,
                            builder: (context, snap) {
                              if (snap.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              if (snap.hasError) {
                                return Text('Error: ${snap.error}');
                              }
                              if (!snap.hasData) {
                                return Text('No data');
                              }
                              final countries = List<CountryModel>.from(
                                snap.data!,
                              );
                              countries.sort((a, b) {
                                final densityA = (a.area == 0)
                                    ? 0.0
                                    : a.pop / a.area;
                                final densityB = (b.area == 0)
                                    ? 0.0
                                    : b.pop / b.area;
                                return densityB.compareTo(densityA);
                              });

                              return ListView.builder(
                                itemCount: countries.length,
                                itemBuilder: (context, index) {
                                  final c = countries[index];
                                  final density = (c.area == 0)
                                      ? 0.0
                                      : c.pop / c.area;
                                  return ListTile(
                                    leading: Image.network(c.flag, width: 20),
                                    title: Text(
                                      c.name,
                                      style: TextStyle(
                                        color: changeColor
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                    ),
                                    trailing: Text(
                                      density.toStringAsFixed(2),
                                      style: TextStyle(
                                        color: changeColor
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
