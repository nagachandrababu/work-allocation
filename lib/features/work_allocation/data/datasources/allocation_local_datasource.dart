import '../../domain/entities/project.dart';
import '../../domain/entities/technician.dart';
import '../../domain/entities/activity.dart';

abstract class AllocationLocalDataSource {
  Future<List> getProjects();
  Future<List> getActivities();
  Future<List> getTechnicians();
  Future<List> getSubcontractorCompanies();
}

class AllocationLocalDataSourceImpl implements AllocationLocalDataSource {
  @override
  Future<List> getProjects() async {
    return const [
      Project(
        id: '1',
        name: 'Creek Vista Heights',
        subDivision: 'Masonry',
        defaultScope: 'SCL',
        towers: ['Tower A', 'Tower B', 'Tower C'],
      ),
      Project(
        id: '2',
        name: 'Marina Gate Residences',
        subDivision: 'Internal Works',
        defaultScope: 'SCL',
        towers: ['Tower A', 'Tower B', 'Tower C'],
      ),
      Project(
        id: '3',
        name: 'Downtown Edge Tower',
        subDivision: 'Electrical',
        defaultScope: 'SCL',
        towers: ['Tower A', 'Tower B', 'Tower C'],
      ),
      Project(
        id: '4',
        name: 'Palm District Villas',
        subDivision: 'Masonry',
        defaultScope: 'Sub Contractor',
        towers: ['Tower A', 'Tower B', 'Tower C'],
      ),
    ];
  }

  @override
  Future<List> getActivities() async {
    return const [
      Activity(
        id: '1',
        name: 'Blockwork',
        subActivities: [
          SubActivity(id: 's1', name: 'Survey Marking', parentActivityName: 'Blockwork'),
          SubActivity(id: 's2', name: 'Block Laying', parentActivityName: 'Blockwork'),
          SubActivity(id: 's3', name: 'Lintel Fixing', parentActivityName: 'Blockwork'),
          SubActivity(id: 's4', name: 'Wall Alignment', parentActivityName: 'Blockwork'),
        ],
      ),
      Activity(
        id: '2',
        name: 'Plastering',
        subActivities: [
          SubActivity(id: 's5', name: 'Surface Preparation', parentActivityName: 'Plastering'),
        ],
      ),
      Activity(
        id: '3',
        name: 'Painting',
        subActivities: [
          SubActivity(id: 's6', name: 'Primer Coat', parentActivityName: 'Painting'),
        ],
      ),
      Activity(
        id: '4',
        name: 'Tile Works',
        subActivities: [
          SubActivity(id: 's7', name: 'Tile Laying', parentActivityName: 'Tile Works'),
        ],
      ),
      Activity(
        id: '5',
        name: 'CHW Pipe Insulation',
        subActivities: [
          SubActivity(id: 's8', name: 'CHW pipe Insulation_25mm dia', parentActivityName: 'CHW Pipe Insulation'),
          SubActivity(id: 's9', name: 'CHW pipe Insulation_32mm dia', parentActivityName: 'CHW Pipe Insulation'),
          SubActivity(id: 's10', name: 'CHW pipe Insulation_40mm dia', parentActivityName: 'CHW Pipe Insulation'),
          SubActivity(id: 's11', name: 'CHW pipe Insulation_50mm dia', parentActivityName: 'CHW Pipe Insulation'),
          SubActivity(id: 's12', name: 'CHW pipe Insulation_65mm dia', parentActivityName: 'CHW Pipe Insulation'),
          SubActivity(id: 's13', name: 'CHW pipe Insulation_80mm dia', parentActivityName: 'CHW Pipe Insulation'),
          SubActivity(id: 's14', name: 'CHW pipe Insulation_100mm dia', parentActivityName: 'CHW Pipe Insulation'),
          SubActivity(id: 's15', name: 'CHW pipe Insulation_125mm dia', parentActivityName: 'CHW Pipe Insulation'),
          SubActivity(id: 's16', name: 'CHW pipe Insulation_150mm dia', parentActivityName: 'CHW Pipe Insulation'),
          SubActivity(id: 's17', name: 'CHW pipe Insulation_200mm dia', parentActivityName: 'CHW Pipe Insulation'),
          SubActivity(id: 's18', name: 'CHW pipe Insulation_250mm dia', parentActivityName: 'CHW Pipe Insulation'),
          SubActivity(id: 's19', name: 'CHW pipe Insulation_300mm dia', parentActivityName: 'CHW Pipe Insulation'),
        ],
      ),
    ];
  }

  @override
  Future<List> getTechnicians() async {
    return const [
      Technician(id: '1001', name: 'Ramesh A', status: TechnicianStatus.present),
      Technician(id: '1002', name: 'Suresh K', status: TechnicianStatus.present),
      Technician(id: '1003', name: 'Manoj P', status: TechnicianStatus.present),
      Technician(id: '1004', name: 'Vikram K', status: TechnicianStatus.absent),
      Technician(id: '1005', name: 'Karthik A', status: TechnicianStatus.present),
      Technician(id: '1006', name: 'Prabhu B', status: TechnicianStatus.absent),
      Technician(id: '1007', name: 'Sanjay J', status: TechnicianStatus.present),
      Technician(id: '1008', name: 'Arun V', status: TechnicianStatus.absent),
      Technician(id: '1009', name: 'Ajith R', status: TechnicianStatus.present),
      Technician(id: '1010', name: 'Ravi M', status: TechnicianStatus.present),
      Technician(id: '1011', name: 'Dinesh P', status: TechnicianStatus.present),
      Technician(id: '1012', name: 'Naveen S', status: TechnicianStatus.absent),
      Technician(id: '1013', name: 'Faisal K', status: TechnicianStatus.present),
      Technician(id: '1014', name: 'Amal V', status: TechnicianStatus.present),
      Technician(id: '1015', name: 'Rahul T', status: TechnicianStatus.absent),
      Technician(id: '1016', name: 'Biju A', status: TechnicianStatus.present),
    ];
  }

  @override
  Future<List> getSubcontractorCompanies() async {
    return const [
      'Alpha Contracting',
      'BuildRight Subcontracting',
      'Gulf Masonry Works',
      'Prime Site Services',
    ];
  }
}