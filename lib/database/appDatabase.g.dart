// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appDatabase.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class HydrationPlan extends DataClass implements Insertable<HydrationPlan> {
  final int id;
  final String gender;
  final String birthday;
  final String wakeupTime;
  final String bedtime;
  final int dailyGoal;
  final String liquidMeasurement;
  final int isUsingRecommendedDailyGoal;
  final String joinedDate;
  HydrationPlan(
      {this.id,
      this.gender,
      this.birthday,
      this.wakeupTime,
      this.bedtime,
      this.dailyGoal,
      this.liquidMeasurement,
      this.isUsingRecommendedDailyGoal,
      this.joinedDate});
  factory HydrationPlan.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return HydrationPlan(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      gender:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}gender']),
      birthday: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}birthday']),
      wakeupTime: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}wakeupTime']),
      bedtime:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}bedtime']),
      dailyGoal:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}dailyGoal']),
      liquidMeasurement: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}liquidMeasurement']),
      isUsingRecommendedDailyGoal: intType.mapFromDatabaseResponse(
          data['${effectivePrefix}isUsingRecommendedDailyGoal']),
      joinedDate: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}joinedDate']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || birthday != null) {
      map['birthday'] = Variable<String>(birthday);
    }
    if (!nullToAbsent || wakeupTime != null) {
      map['wakeupTime'] = Variable<String>(wakeupTime);
    }
    if (!nullToAbsent || bedtime != null) {
      map['bedtime'] = Variable<String>(bedtime);
    }
    if (!nullToAbsent || dailyGoal != null) {
      map['dailyGoal'] = Variable<int>(dailyGoal);
    }
    if (!nullToAbsent || liquidMeasurement != null) {
      map['liquidMeasurement'] = Variable<String>(liquidMeasurement);
    }
    if (!nullToAbsent || isUsingRecommendedDailyGoal != null) {
      map['isUsingRecommendedDailyGoal'] =
          Variable<int>(isUsingRecommendedDailyGoal);
    }
    if (!nullToAbsent || joinedDate != null) {
      map['joinedDate'] = Variable<String>(joinedDate);
    }
    return map;
  }

  HydrationPlansCompanion toCompanion(bool nullToAbsent) {
    return HydrationPlansCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      gender:
          gender == null && nullToAbsent ? const Value.absent() : Value(gender),
      birthday: birthday == null && nullToAbsent
          ? const Value.absent()
          : Value(birthday),
      wakeupTime: wakeupTime == null && nullToAbsent
          ? const Value.absent()
          : Value(wakeupTime),
      bedtime: bedtime == null && nullToAbsent
          ? const Value.absent()
          : Value(bedtime),
      dailyGoal: dailyGoal == null && nullToAbsent
          ? const Value.absent()
          : Value(dailyGoal),
      liquidMeasurement: liquidMeasurement == null && nullToAbsent
          ? const Value.absent()
          : Value(liquidMeasurement),
      isUsingRecommendedDailyGoal:
          isUsingRecommendedDailyGoal == null && nullToAbsent
              ? const Value.absent()
              : Value(isUsingRecommendedDailyGoal),
      joinedDate: joinedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(joinedDate),
    );
  }

  factory HydrationPlan.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return HydrationPlan(
      id: serializer.fromJson<int>(json['id']),
      gender: serializer.fromJson<String>(json['gender']),
      birthday: serializer.fromJson<String>(json['birthday']),
      wakeupTime: serializer.fromJson<String>(json['wakeupTime']),
      bedtime: serializer.fromJson<String>(json['bedtime']),
      dailyGoal: serializer.fromJson<int>(json['dailyGoal']),
      liquidMeasurement: serializer.fromJson<String>(json['liquidMeasurement']),
      isUsingRecommendedDailyGoal:
          serializer.fromJson<int>(json['isUsingRecommendedDailyGoal']),
      joinedDate: serializer.fromJson<String>(json['joinedDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gender': serializer.toJson<String>(gender),
      'birthday': serializer.toJson<String>(birthday),
      'wakeupTime': serializer.toJson<String>(wakeupTime),
      'bedtime': serializer.toJson<String>(bedtime),
      'dailyGoal': serializer.toJson<int>(dailyGoal),
      'liquidMeasurement': serializer.toJson<String>(liquidMeasurement),
      'isUsingRecommendedDailyGoal':
          serializer.toJson<int>(isUsingRecommendedDailyGoal),
      'joinedDate': serializer.toJson<String>(joinedDate),
    };
  }

  HydrationPlan copyWith(
          {int id,
          String gender,
          String birthday,
          String wakeupTime,
          String bedtime,
          int dailyGoal,
          String liquidMeasurement,
          int isUsingRecommendedDailyGoal,
          String joinedDate}) =>
      HydrationPlan(
        id: id ?? this.id,
        gender: gender ?? this.gender,
        birthday: birthday ?? this.birthday,
        wakeupTime: wakeupTime ?? this.wakeupTime,
        bedtime: bedtime ?? this.bedtime,
        dailyGoal: dailyGoal ?? this.dailyGoal,
        liquidMeasurement: liquidMeasurement ?? this.liquidMeasurement,
        isUsingRecommendedDailyGoal:
            isUsingRecommendedDailyGoal ?? this.isUsingRecommendedDailyGoal,
        joinedDate: joinedDate ?? this.joinedDate,
      );
  @override
  String toString() {
    return (StringBuffer('HydrationPlan(')
          ..write('id: $id, ')
          ..write('gender: $gender, ')
          ..write('birthday: $birthday, ')
          ..write('wakeupTime: $wakeupTime, ')
          ..write('bedtime: $bedtime, ')
          ..write('dailyGoal: $dailyGoal, ')
          ..write('liquidMeasurement: $liquidMeasurement, ')
          ..write('isUsingRecommendedDailyGoal: $isUsingRecommendedDailyGoal, ')
          ..write('joinedDate: $joinedDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          gender.hashCode,
          $mrjc(
              birthday.hashCode,
              $mrjc(
                  wakeupTime.hashCode,
                  $mrjc(
                      bedtime.hashCode,
                      $mrjc(
                          dailyGoal.hashCode,
                          $mrjc(
                              liquidMeasurement.hashCode,
                              $mrjc(isUsingRecommendedDailyGoal.hashCode,
                                  joinedDate.hashCode)))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is HydrationPlan &&
          other.id == this.id &&
          other.gender == this.gender &&
          other.birthday == this.birthday &&
          other.wakeupTime == this.wakeupTime &&
          other.bedtime == this.bedtime &&
          other.dailyGoal == this.dailyGoal &&
          other.liquidMeasurement == this.liquidMeasurement &&
          other.isUsingRecommendedDailyGoal ==
              this.isUsingRecommendedDailyGoal &&
          other.joinedDate == this.joinedDate);
}

class HydrationPlansCompanion extends UpdateCompanion<HydrationPlan> {
  final Value<int> id;
  final Value<String> gender;
  final Value<String> birthday;
  final Value<String> wakeupTime;
  final Value<String> bedtime;
  final Value<int> dailyGoal;
  final Value<String> liquidMeasurement;
  final Value<int> isUsingRecommendedDailyGoal;
  final Value<String> joinedDate;
  const HydrationPlansCompanion({
    this.id = const Value.absent(),
    this.gender = const Value.absent(),
    this.birthday = const Value.absent(),
    this.wakeupTime = const Value.absent(),
    this.bedtime = const Value.absent(),
    this.dailyGoal = const Value.absent(),
    this.liquidMeasurement = const Value.absent(),
    this.isUsingRecommendedDailyGoal = const Value.absent(),
    this.joinedDate = const Value.absent(),
  });
  HydrationPlansCompanion.insert({
    this.id = const Value.absent(),
    this.gender = const Value.absent(),
    this.birthday = const Value.absent(),
    this.wakeupTime = const Value.absent(),
    this.bedtime = const Value.absent(),
    this.dailyGoal = const Value.absent(),
    this.liquidMeasurement = const Value.absent(),
    this.isUsingRecommendedDailyGoal = const Value.absent(),
    this.joinedDate = const Value.absent(),
  });
  static Insertable<HydrationPlan> custom({
    Expression<int> id,
    Expression<String> gender,
    Expression<String> birthday,
    Expression<String> wakeupTime,
    Expression<String> bedtime,
    Expression<int> dailyGoal,
    Expression<String> liquidMeasurement,
    Expression<int> isUsingRecommendedDailyGoal,
    Expression<String> joinedDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gender != null) 'gender': gender,
      if (birthday != null) 'birthday': birthday,
      if (wakeupTime != null) 'wakeupTime': wakeupTime,
      if (bedtime != null) 'bedtime': bedtime,
      if (dailyGoal != null) 'dailyGoal': dailyGoal,
      if (liquidMeasurement != null) 'liquidMeasurement': liquidMeasurement,
      if (isUsingRecommendedDailyGoal != null)
        'isUsingRecommendedDailyGoal': isUsingRecommendedDailyGoal,
      if (joinedDate != null) 'joinedDate': joinedDate,
    });
  }

  HydrationPlansCompanion copyWith(
      {Value<int> id,
      Value<String> gender,
      Value<String> birthday,
      Value<String> wakeupTime,
      Value<String> bedtime,
      Value<int> dailyGoal,
      Value<String> liquidMeasurement,
      Value<int> isUsingRecommendedDailyGoal,
      Value<String> joinedDate}) {
    return HydrationPlansCompanion(
      id: id ?? this.id,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      wakeupTime: wakeupTime ?? this.wakeupTime,
      bedtime: bedtime ?? this.bedtime,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      liquidMeasurement: liquidMeasurement ?? this.liquidMeasurement,
      isUsingRecommendedDailyGoal:
          isUsingRecommendedDailyGoal ?? this.isUsingRecommendedDailyGoal,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (birthday.present) {
      map['birthday'] = Variable<String>(birthday.value);
    }
    if (wakeupTime.present) {
      map['wakeupTime'] = Variable<String>(wakeupTime.value);
    }
    if (bedtime.present) {
      map['bedtime'] = Variable<String>(bedtime.value);
    }
    if (dailyGoal.present) {
      map['dailyGoal'] = Variable<int>(dailyGoal.value);
    }
    if (liquidMeasurement.present) {
      map['liquidMeasurement'] = Variable<String>(liquidMeasurement.value);
    }
    if (isUsingRecommendedDailyGoal.present) {
      map['isUsingRecommendedDailyGoal'] =
          Variable<int>(isUsingRecommendedDailyGoal.value);
    }
    if (joinedDate.present) {
      map['joinedDate'] = Variable<String>(joinedDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HydrationPlansCompanion(')
          ..write('id: $id, ')
          ..write('gender: $gender, ')
          ..write('birthday: $birthday, ')
          ..write('wakeupTime: $wakeupTime, ')
          ..write('bedtime: $bedtime, ')
          ..write('dailyGoal: $dailyGoal, ')
          ..write('liquidMeasurement: $liquidMeasurement, ')
          ..write('isUsingRecommendedDailyGoal: $isUsingRecommendedDailyGoal, ')
          ..write('joinedDate: $joinedDate')
          ..write(')'))
        .toString();
  }
}

class HydrationPlans extends Table
    with TableInfo<HydrationPlans, HydrationPlan> {
  final GeneratedDatabase _db;
  final String _alias;
  HydrationPlans(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, true, $customConstraints: '');
  }

  final VerificationMeta _genderMeta = const VerificationMeta('gender');
  GeneratedTextColumn _gender;
  GeneratedTextColumn get gender => _gender ??= _constructGender();
  GeneratedTextColumn _constructGender() {
    return GeneratedTextColumn('gender', $tableName, true,
        $customConstraints: '');
  }

  final VerificationMeta _birthdayMeta = const VerificationMeta('birthday');
  GeneratedTextColumn _birthday;
  GeneratedTextColumn get birthday => _birthday ??= _constructBirthday();
  GeneratedTextColumn _constructBirthday() {
    return GeneratedTextColumn('birthday', $tableName, true,
        $customConstraints: '');
  }

  final VerificationMeta _wakeupTimeMeta = const VerificationMeta('wakeupTime');
  GeneratedTextColumn _wakeupTime;
  GeneratedTextColumn get wakeupTime => _wakeupTime ??= _constructWakeupTime();
  GeneratedTextColumn _constructWakeupTime() {
    return GeneratedTextColumn('wakeupTime', $tableName, true,
        $customConstraints: '');
  }

  final VerificationMeta _bedtimeMeta = const VerificationMeta('bedtime');
  GeneratedTextColumn _bedtime;
  GeneratedTextColumn get bedtime => _bedtime ??= _constructBedtime();
  GeneratedTextColumn _constructBedtime() {
    return GeneratedTextColumn('bedtime', $tableName, true,
        $customConstraints: '');
  }

  final VerificationMeta _dailyGoalMeta = const VerificationMeta('dailyGoal');
  GeneratedIntColumn _dailyGoal;
  GeneratedIntColumn get dailyGoal => _dailyGoal ??= _constructDailyGoal();
  GeneratedIntColumn _constructDailyGoal() {
    return GeneratedIntColumn('dailyGoal', $tableName, true,
        $customConstraints: '');
  }

  final VerificationMeta _liquidMeasurementMeta =
      const VerificationMeta('liquidMeasurement');
  GeneratedTextColumn _liquidMeasurement;
  GeneratedTextColumn get liquidMeasurement =>
      _liquidMeasurement ??= _constructLiquidMeasurement();
  GeneratedTextColumn _constructLiquidMeasurement() {
    return GeneratedTextColumn('liquidMeasurement', $tableName, true,
        $customConstraints: '');
  }

  final VerificationMeta _isUsingRecommendedDailyGoalMeta =
      const VerificationMeta('isUsingRecommendedDailyGoal');
  GeneratedIntColumn _isUsingRecommendedDailyGoal;
  GeneratedIntColumn get isUsingRecommendedDailyGoal =>
      _isUsingRecommendedDailyGoal ??= _constructIsUsingRecommendedDailyGoal();
  GeneratedIntColumn _constructIsUsingRecommendedDailyGoal() {
    return GeneratedIntColumn('isUsingRecommendedDailyGoal', $tableName, true,
        $customConstraints: '');
  }

  final VerificationMeta _joinedDateMeta = const VerificationMeta('joinedDate');
  GeneratedTextColumn _joinedDate;
  GeneratedTextColumn get joinedDate => _joinedDate ??= _constructJoinedDate();
  GeneratedTextColumn _constructJoinedDate() {
    return GeneratedTextColumn('joinedDate', $tableName, true,
        $customConstraints: '');
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        gender,
        birthday,
        wakeupTime,
        bedtime,
        dailyGoal,
        liquidMeasurement,
        isUsingRecommendedDailyGoal,
        joinedDate
      ];
  @override
  HydrationPlans get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'hydrationPlans';
  @override
  final String actualTableName = 'hydrationPlans';
  @override
  VerificationContext validateIntegrity(Insertable<HydrationPlan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender'], _genderMeta));
    }
    if (data.containsKey('birthday')) {
      context.handle(_birthdayMeta,
          birthday.isAcceptableOrUnknown(data['birthday'], _birthdayMeta));
    }
    if (data.containsKey('wakeupTime')) {
      context.handle(
          _wakeupTimeMeta,
          wakeupTime.isAcceptableOrUnknown(
              data['wakeupTime'], _wakeupTimeMeta));
    }
    if (data.containsKey('bedtime')) {
      context.handle(_bedtimeMeta,
          bedtime.isAcceptableOrUnknown(data['bedtime'], _bedtimeMeta));
    }
    if (data.containsKey('dailyGoal')) {
      context.handle(_dailyGoalMeta,
          dailyGoal.isAcceptableOrUnknown(data['dailyGoal'], _dailyGoalMeta));
    }
    if (data.containsKey('liquidMeasurement')) {
      context.handle(
          _liquidMeasurementMeta,
          liquidMeasurement.isAcceptableOrUnknown(
              data['liquidMeasurement'], _liquidMeasurementMeta));
    }
    if (data.containsKey('isUsingRecommendedDailyGoal')) {
      context.handle(
          _isUsingRecommendedDailyGoalMeta,
          isUsingRecommendedDailyGoal.isAcceptableOrUnknown(
              data['isUsingRecommendedDailyGoal'],
              _isUsingRecommendedDailyGoalMeta));
    }
    if (data.containsKey('joinedDate')) {
      context.handle(
          _joinedDateMeta,
          joinedDate.isAcceptableOrUnknown(
              data['joinedDate'], _joinedDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  HydrationPlan map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return HydrationPlan.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  HydrationPlans createAlias(String alias) {
    return HydrationPlans(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  HydrationPlans _hydrationPlans;
  HydrationPlans get hydrationPlans => _hydrationPlans ??= HydrationPlans(this);
  Selectable<HydrationPlan> readHydrationPlan() {
    return customSelect('SELECT * FROM hydrationPlans',
        variables: [],
        readsFrom: {hydrationPlans}).map(hydrationPlans.mapFromRow);
  }

  Future<int> createHydrationPlan(String var1, String var2, String var3,
      String var4, int var5, String var6, int var7, String var8) {
    return customInsert(
      'INSERT INTO hydrationPlans VALUES (1, ?, ?, ?, ?, ?, ?, ?, ?)',
      variables: [
        Variable<String>(var1),
        Variable<String>(var2),
        Variable<String>(var3),
        Variable<String>(var4),
        Variable<int>(var5),
        Variable<String>(var6),
        Variable<int>(var7),
        Variable<String>(var8)
      ],
      updates: {hydrationPlans},
    );
  }

  Future<int> deleteHydrationPlan() {
    return customUpdate(
      'DELETE FROM hydrationPlans WHERE id = 1',
      variables: [],
      updates: {hydrationPlans},
      updateKind: UpdateKind.delete,
    );
  }

  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [hydrationPlans];
}
