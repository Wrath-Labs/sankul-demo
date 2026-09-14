/// Name and context pools for generating realistic rosters outside the
/// hand-written showcase classes.
const boyNames = [
  'Aarav', 'Vivaan', 'Aditya', 'Arjun', 'Reyansh', 'Krishna', 'Ishaan',
  'Shaurya', 'Atharv', 'Ayaan', 'Dhruv', 'Arnav', 'Rudra', 'Yash', 'Harsh',
  'Kartik', 'Pranav', 'Rohan', 'Aniket', 'Siddharth', 'Utkarsh', 'Devansh',
  'Parth', 'Lakshya', 'Anmol', 'Vedant', 'Tanmay', 'Ritvik', 'Samar',
  'Nikhil', 'Aryan', 'Mohit', 'Sahil', 'Abhinav', 'Gaurav', 'Manan',
  'Prateek', 'Harshit', 'Divyansh', 'Naman', 'Kunal', 'Shivansh', 'Madhav',
  'Raghav', 'Vansh', 'Chirag', 'Priyansh', 'Ansh', 'Ayush', 'Keshav',
];

const girlNames = [
  'Ananya', 'Diya', 'Saanvi', 'Aadhya', 'Myra', 'Pari', 'Anika', 'Navya',
  'Kavya', 'Ishita', 'Riya', 'Aditi', 'Khushi', 'Sneha', 'Tanvi', 'Shreya',
  'Prachi', 'Nandini', 'Muskan', 'Vanshika', 'Palak', 'Radhika', 'Sakshi',
  'Anushka', 'Kritika', 'Mahi', 'Jiya', 'Siya', 'Avni', 'Tanya', 'Srishti',
  'Garima', 'Aarohi', 'Kashvi', 'Ira', 'Nikita', 'Vaishnavi', 'Mansi',
  'Harshita', 'Lavanya', 'Charvi', 'Mehak', 'Yashika', 'Divya', 'Sanya',
  'Bhavya', 'Aanya', 'Rashi', 'Kiara', 'Tamanna',
];

const surnames = [
  'Sharma', 'Agarwal', 'Gupta', 'Verma', 'Singh', 'Yadav', 'Kushwaha',
  'Chauhan', 'Jain', 'Goyal', 'Mittal', 'Bansal', 'Saxena', 'Srivastava',
  'Mishra', 'Pandey', 'Tiwari', 'Dubey', 'Rajput', 'Tomar', 'Sikarwar',
  'Khandelwal', 'Maheshwari', 'Garg', 'Singhal', 'Rathore', 'Chaudhary',
  'Bhardwaj', 'Mathur', 'Tyagi', 'Soni', 'Kapoor', 'Varshney',
  'Kulshrestha', 'Chaturvedi', 'Jaiswal', 'Bhatnagar', 'Dixit',
];

const muslimBoyNames = ['Ayaan', 'Arham', 'Rehan', 'Zaid', 'Faizan', 'Ahad'];
const muslimGirlNames = ['Zoya', 'Alina', 'Inaya', 'Sana', 'Aleena', 'Mahira'];
const muslimSurnames = ['Khan', 'Qureshi', 'Ansari', 'Siddiqui', 'Mirza'];

const fatherNames = [
  'Rajesh', 'Sanjay', 'Amit', 'Vikas', 'Manoj', 'Ashok', 'Rakesh', 'Sunil',
  'Anil', 'Deepak', 'Pankaj', 'Vinod', 'Pradeep', 'Rahul', 'Nitin', 'Alok',
  'Sachin', 'Vivek', 'Ajay', 'Mukesh', 'Sandeep', 'Arvind', 'Naveen',
  'Gaurav', 'Rohit', 'Sumit', 'Harish', 'Yogesh', 'Dinesh', 'Ravi', 'Anuj',
  'Lalit', 'Manish', 'Kapil', 'Saurabh', 'Hemant', 'Abhishek', 'Tarun',
];

const motherNames = [
  'Sunita', 'Neha', 'Pooja', 'Priya', 'Anita', 'Kavita', 'Rekha', 'Seema',
  'Ritu', 'Meena', 'Shalini', 'Deepti', 'Swati', 'Nidhi', 'Preeti', 'Anjali',
  'Monika', 'Rashmi', 'Sarita', 'Geeta', 'Poonam', 'Shweta', 'Archana',
  'Vandana', 'Rachna', 'Ruchi', 'Shikha', 'Megha', 'Sonal', 'Pallavi',
];

const muslimFatherNames = ['Imran', 'Salman', 'Arif', 'Javed', 'Faisal', 'Irfan'];
const muslimMotherNames = ['Shabana', 'Nazia', 'Farah', 'Rukhsar', 'Sana', 'Heena'];

const occupations = [
  'Business', 'Private Service', 'Government Service', 'Doctor', 'Advocate',
  'Teacher', 'Engineer', 'Shopkeeper', 'Chartered Accountant', 'Bank Officer',
  'Business (Leather Exports)', 'Business (Marble & Handicrafts)',
  'Business (Footwear)', 'Farmer & Landowner', 'Pharmacist', 'Contractor',
  'Wholesale Trader', 'Indian Army', 'Police', 'Railways',
];

/// Agra localities → PIN code.
const localities = <String, String>{
  'Kamla Nagar': '282005',
  'Dayal Bagh': '282005',
  'Sikandra': '282007',
  'Shastripuram': '282007',
  'Civil Lines': '282002',
  'Sanjay Place': '282002',
  'Tajganj': '282001',
  'Lohamandi': '282002',
  'Bodla': '282007',
  'Awas Vikas Colony': '282007',
  'Khandari': '282005',
  'Trans Yamuna Colony': '282006',
  'Shahganj': '282010',
  'Balkeshwar': '282005',
  'Rawatpara': '282003',
  'Fatehabad Road': '282001',
  'Rambagh': '282006',
};

const phonePrefixes = [
  '98370', '94120', '97190', '88810', '70178', '99270', '63971', '80060',
  '95576', '76180', '93585', '90450',
];

/// Blood groups weighted roughly by Indian prevalence.
const bloodGroupWeights = <String, int>{
  'B+': 30, 'O+': 28, 'A+': 22, 'AB+': 8, 'B-': 4, 'O-': 3, 'A-': 3, 'AB-': 2,
};
