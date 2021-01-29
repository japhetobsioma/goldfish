double calculateWaterGoal(int age, String gender) {
  double waterGoal;

  if (gender == 'Male') {
    if (age >= 19) {
      waterGoal = 3.7;
    } else if (age >= 14) {
      waterGoal = 3.3;
    } else if (age >= 9) {
      waterGoal = 2.4;
    }
  } else {
    if (age >= 19) {
      waterGoal = 2.7;
    } else if (age >= 14) {
      waterGoal = 2.3;
    } else if (age >= 9) {
      waterGoal = 2.1;
    }
  }

  if (age == 0) {
    waterGoal = 0.8;
  } else if (age <= 3) {
    waterGoal = 1.3;
  } else if (age <= 8) {
    waterGoal = 1.7;
  }

  return waterGoal;
}
