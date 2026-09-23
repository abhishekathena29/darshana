import 'package:cloud_firestore/cloud_firestore.dart';
import 'temple_repository.dart';
import 'event_repository.dart';
import '../models/temple_model.dart';
import '../models/event_model.dart';

/// Dev utility to populate Firestore with realistic starter content
/// (a temple, several events, a sacred path), owned by the given
/// (temple-role) account's uid. Not wired to any UI — invoke it manually
/// (e.g. from a debug console/script) when you need to re-seed a fresh
/// Firestore project.
class SeedService {
  final _firestore = FirebaseFirestore.instance;
  final _temples = TempleRepository();
  final _events = EventRepository();

  Future<void> seed(String ownerId) async {
    final templeId = await _temples.create(TempleModel(
      id: '',
      ownerId: ownerId,
      name: 'Sri Padmavathi Amman Temple',
      deity: 'Lord Venkateswara',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBEIysNsnaCmGG66ptZVYbNLQMpvUp5Rum0BtwLES3_dAy33tJgiO0JXyEKzzHQDOla1LInCvpJpMtPUPgAzZAE5jaba3OmZ8fUfIN1MazcsbiOYwXODxXiqOqcNe9HbKkNFjMkCMquR8D82CyVA4dJmPuXXDtWwQOLfu15Xn9v5l4nXV-MfcL3YjBcFpFDUp-V7UH8p1aQ6juOzICo9s59WUz11ETiUF-KB5u_iGawT92gBWlTCPqCJUCl-EOAjsmTqEtxyTSgYO4',
      location: 'Tiruchanur',
      timings: '5:30 AM - 9:00 PM',
      dressCode: 'Traditional Only',
      significance:
          'The temple is dedicated to Goddess Padmavathi, the consort of Lord Venkateswara. '
          'Legend has it that she manifested in a golden lotus within the temple tank. '
          'Pilgrims traditionally visit this sacred site before proceeding to Tirumala.',
      history: 'Ancient structures dating back to the Pallava era, reflecting Dravidian architectural mastery.',
      architecture: 'Intricate stone carvings and a magnificent seven-tier Rajagopuram facing the sunrise.',
      proTips: const [
        'Carry a reusable water bottle; hydration points are available.',
        'Photography is strictly prohibited inside the sanctum.',
        'Shoe counters are free and located at the South entrance.',
      ],
      facilities: const [
        TempleFacility(icon: 'accessible', title: 'ACCESS', subtitle: 'Ramp & Lift'),
        TempleFacility(icon: 'parking', title: 'PARKING', subtitle: 'Secured Lot'),
        TempleFacility(icon: 'food', title: 'FOOD', subtitle: 'Annaprasadam'),
        TempleFacility(icon: 'wifi', title: 'DIGITAL', subtitle: 'Public WiFi'),
      ],
      officialPortal: 'tirumala.org',
    ));

    await _temples.create(TempleModel(
      id: '',
      ownerId: ownerId,
      name: 'Meenakshi Amman Temple',
      deity: 'Goddess Meenakshi',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAC8-zMkY0RUdyrxAovlboegmsa1i850vK4UYOW1npJYZ8qpzn8VVFvubu6NobRMJYw_D8ddNSNKWo9geBdFjGra9OC_Numy_5HwrqcNFc90RvxDf_H5YDEhAE0F0IozP9XknQqHEtG8vy7zoidQHyel4kucnXORcpJvuGUvn-lu6bmptUoL4uzXW54soy1wL6ZOOWd2JL-zpeFZHeI_Zcr4XFV3Ks_Zi9OPPcmqU_Rscp4gSGSjPoyLDt6OXJsj2UN1xMKSgDpO20',
      location: 'Madurai, Tamil Nadu',
      timings: '5:00 AM - 9:30 PM',
      dressCode: 'Traditional Only',
      significance: 'The heart of Madurai, known for its 14 gopurams and thousands of vibrant sculptures.',
      history: 'One of the oldest temple complexes in South India, central to Madurai\'s cultural identity.',
      architecture: 'Fourteen gopurams covered in over 33,000 sculptures of gods, demons and heroes.',
      officialPortal: '',
    ));

    final now = DateTime.now();
    await _events.create(EventModel(
      id: '',
      ownerId: ownerId,
      templeId: templeId,
      title: 'Maha Shivratri Celebration',
      badge: 'LIVE NOW',
      category: 'Festivals',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAdfhQvhLaA6RCxWiMBr5WGMj45NMtcXqh5pCqRAbDUwP82kWQOdBKvuGuVH-17ofDfeBL5xkHxSC2tVdHI4-kV9vuAIZjpJRq5v9PQ30dMZdu5G2qJouof4ozjEsMKBi4nRIWujx1YN4kUzCKDIgLg8yLx23henCcOjssPwd5RaFCxUmowLuGjiWYqSM0HdwcGy2zerbjscMUvNy6zuNdLEXWkB_TL8D-scncSf0JnI3MKjah47UjAgSiRoTU2DRoK9ob667-h5Ro',
      date: now.add(const Duration(days: 1)),
      dateText: 'Tonight',
      startTime: '6:00 PM',
      venue: 'Varanasi Ghats, India',
      durationText: '4 Hours',
      description: 'A grand night-long celebration of Lord Shiva with continuous chanting, abhishekam and cultural performances.',
      price: 0,
    ));

    await _events.create(EventModel(
      id: '',
      ownerId: ownerId,
      templeId: templeId,
      title: 'Vedic Chanting Workshop',
      badge: '',
      category: 'Poojas',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDTCs4Ew6tFzt1nRh-5bq9svMtGid7nJ2_Rw56gsMjte8ZY3Ing4kAqlgIjCqO_TJlIuW2zjhPyg4DZOdJNhBlK9W0bqybuec55zfoJCCSsMMiTJZ5Ek_BAB2MOrjukoRemRLT7tIHMQZvrBKvphSxdVhEHJRWMZxN5DtOs1gTSYt7HiyyfkfuqukO-MFeJgP65ru7vaEv5HSF_Y40nmrEEUZLXiWNv2JiLqC1glFI7sEpPvK7w3_Pt-Q2pbM2Yh7tIhsXx0fikVVM',
      date: now.add(const Duration(days: 4)),
      dateText: 'Mar 18',
      startTime: '10:00 AM - 1:00 PM',
      venue: 'The Lotus Center, Rishikesh',
      durationText: '3 Hours',
      description: 'Learn the fundamentals of Vedic chanting from resident scholars in a small-group setting.',
      price: 250,
      capacity: 30,
    ));

    await _events.create(EventModel(
      id: '',
      ownerId: ownerId,
      templeId: templeId,
      title: 'Evening Raga & Meditation',
      badge: '',
      category: 'Music',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAGMEp4Hy7LocA-Jbs1JA9gwrhwHpPQlf7P35k00XW4PyN0gFC3mRP49dtcr4fet9WUSUOhFolnSSwutNOgy_bjucl_XJDyrXTab1gttAUU6t66To7b3MlUA64oEJFj8YeWJ3mEFHEWRydtOqpv0cM6Y0s49eujgURaVESFfze3QkmSQKT15pvzMhqKgcjj2RxGPznmKDeFKh8unTLTLC9qkHWlBdd7Ikv2sTUNKxab6jZeX8WopNLCgrtVrzZCU_ikSLGQzSL5eLQ',
      date: now.add(const Duration(days: 8)),
      dateText: 'Mar 22',
      startTime: '6:30 PM',
      venue: 'Music Academy',
      durationText: '2 Hours',
      description: 'A soul-stirring performance by maestros in the heart of the sacred valley.',
      price: 1250,
      capacity: 200,
    ));

    await _events.create(EventModel(
      id: '',
      ownerId: ownerId,
      templeId: templeId,
      title: 'Saraswati Puja Gathering',
      badge: '',
      category: 'Poojas',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCZ-trqgjaEbqIsoQ-OcuSVuvJvmvu-j3z4EyuIAdCvstBY7KEe-LNW_-3A6abxJOqk9dCwFprdOynMKV0_snDq2MvFGx1wQxUmABVNKesSd0igExXJRvsqsaMoWz44W04Y10R4jjjfV7679NiAfSmuqgzoLp4sINEBndyclc1yu66vbjjhaR-bXoaN6jv7mnrshSYu2zFTYnKUxP9Smh1H6vdtypurfNJ0NO6SUAYk1wQdv_Pg4VwQSXcvC-r5-lClGGzIDRAqW1w',
      date: now.add(const Duration(days: 10)),
      dateText: 'Mar 25',
      startTime: '9:00 AM Daily',
      venue: 'Community Hall, South Extension',
      durationText: '2 Hours',
      description: 'Traditional Saraswati Puja with sacred readings and prasadam distribution.',
      price: 0,
    ));

    await _firestore.collection('sacredPaths').add({
      'title': 'The Southern Trail',
      'description':
          'A curated spiritual itinerary traversing the ancient Dravidian architectural marvels, '
          'designed to harmonize with traditional pooja timings.',
      'stops': [
        {
          'title': 'Meenakshi Amman Temple',
          'subtitle': 'Morning Darshan & Architectural Walk',
          'time': '06:00 AM',
          'imageUrl':
              'https://lh3.googleusercontent.com/aida-public/AB6AXuB4TCv2GLI-N3uZgpDitEt2sbyt3FqRpAn0lVu0RvqduamDW2PR176nnlqsrOnEbrutRHoLNR-aQ1Wz8h_beSjtWokPrY7h0V3zJogzN_JBo9p7zp35cyXyqoJOWlPsfNvDqPw3ylx9zIY0AMXd2OuE5jp3c-3SHwnWAMyKEoUfacP--HaVMuQOzcTWOW-_WayOram9CoSoMcEM5iGIw7AK2OWS-Lj76bXAMinjaM7IF2UXe0_1x3lRnr_aRf2bI4_Go-mFPjZg38A',
        },
        {
          'title': 'Thirumalai Nayakkar Mahal',
          'subtitle': 'Heritage Exploration',
          'time': '11:30 AM',
          'imageUrl':
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCQsrlmk8xvGBIUL0Nto3N4GDdLGD39x2LJpScU_R-AtAsQri0UhJLbzopDsXo4e818-uzqJG1IT7KRDUotk6O3o8h0sJNtBnWiozul5GXnledQOH3hoH9EbLP6O9gCDOYSatv7tGzgyQCoEYa1boufDACN0WE-j02kdmE33WX88_1z5uQem7dtZ3jYTsuXVt81sDwZoT8HDToyV1rj_J4NBAxkS5daqJQLdXsiwUH30QCHFu_Ax_3-KWk5RGpiE0YubWjcW2A-bdQ',
        },
        {
          'title': 'Alagar Koyil',
          'subtitle': 'Evening Seva & Prasad',
          'time': '05:00 PM',
          'imageUrl':
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAkbUUL3LD2XW7P4NeeBH0w8Zu6r07ojwBEB0hqmyjq2mMeS_TaQ6SDqQDYYOkuovBf0LC6gmS_WBbPDNsMStVAo2C-Pcn4SsLc7dVqvUjCPNnKf2NZr8XFhAVKTUdp_VMY_It6NfGtzWrtrFm4g-Lp3wh4LvzWklbjxeiyT1SoDXatS4Kje6NZBgyKPi8jQ_H-d0tzk6unxOP0RQf3KzE0nUILDaG3esLQ23ZVpZSNsKlKZmkAUvQYZoKtYw8A_FiW3WoLImlo4aA',
        },
      ],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
