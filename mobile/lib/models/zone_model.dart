final List<Map<String, dynamic>> zones = [
  {
    'level': 'Level 1',
    'zones': [
      {
        'name': 'Zone A',
        'slots': [
          {'id': 'AC01', 'type': 'car', 'available': false},
          {'id': 'AC02', 'type': 'car', 'available': false},
          {'id': 'AC03', 'type': 'car', 'available': false},
          {'id': 'AC04', 'type': 'car', 'available': true},
          {'id': 'AC05', 'type': 'car', 'available': true},
          {'id': 'AC06', 'type': 'car', 'available': true},
          {'id': 'AC07', 'type': 'car', 'available': false},
          {'id': 'AC08', 'type': 'car', 'available': true},
          {'id': 'AC09', 'type': 'car', 'available': false},
          {'id': 'AC10', 'type': 'car', 'available': true},
        ],
      },
      {
        'name': 'Zone B',
        'slots': [
          {'id': 'BC01', 'type': 'bike', 'available': true},
          {'id': 'BC02', 'type': 'bike', 'available': false},
          {'id': 'BC03', 'type': 'bike', 'available': true},
          {'id': 'BC04', 'type': 'bike', 'available': true},
          {'id': 'BC05', 'type': 'bike', 'available': false},
          {'id': 'BC06', 'type': 'bike', 'available': false},
          {'id': 'BC07', 'type': 'bike', 'available': true},
          {'id': 'BC08', 'type': 'bike', 'available': true},
          {'id': 'BC09', 'type': 'bike', 'available': false},
          {'id': 'BC10', 'type': 'bike', 'available': true},
        ],
      },
      {
        'name': 'Zone C',
        'slots': [
          {'id': 'CC01', 'type': '3wheel', 'available': false},
          {'id': 'CC02', 'type': '3wheel', 'available': true},
          {'id': 'CC03', 'type': '3wheel', 'available': true},
          {'id': 'CC04', 'type': '3wheel', 'available': false},
          {'id': 'CC05', 'type': '3wheel', 'available': true},
          {'id': 'CC06', 'type': '3wheel', 'available': true},
          {'id': 'CC07', 'type': '3wheel', 'available': false},
          {'id': 'CC08', 'type': '3wheel', 'available': false},
          {'id': 'CC09', 'type': '3wheel', 'available': true},
          {'id': 'CC10', 'type': '3wheel', 'available': false},
        ],
      },
    ],
  },

  {
    'level': 'Level 2',
    'zones': [
      {
        'name': 'Zone A',
        'slots': [
          {'id': 'L2A01', 'type': 'car', 'available': true},
          {'id': 'L2A02', 'type': 'bike', 'available': false},
        ],
      },
    ],
  },

  {
    'level': 'Level 3',
    'zones': [
      {
        'name': 'Zone A',
        'slots': [
          {'id': 'L3A01', 'type': '3wheel', 'available': true},
        ],
      },
    ],
  },
];

int currentZoneIndex = 0;
