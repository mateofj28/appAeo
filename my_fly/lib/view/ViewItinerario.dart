class ViewItinerario {
  int _id;
  String _namePort, _namePortEnd, _source, _destiny, _startTime, _endTime;
  String _starDate, _endDate;

  ViewItinerario(
      this._id,
      this._source,
      this._namePort,
      this._starDate,
      this._startTime,
      this._destiny,
      this._namePortEnd,
      this._endDate,
      this._endTime);

  get endDate => _endDate;

  set endDate(value) {
    _endDate = value;
  }

  String get starDate => _starDate;

  set starDate(String value) {
    _starDate = value;
  }

  get endTime => _endTime;

  set endTime(value) {
    _endTime = value;
  }

  get startTime => _startTime;

  set startTime(value) {
    _startTime = value;
  }

  get destiny => _destiny;

  set destiny(value) {
    _destiny = value;
  }

  get source => _source;

  set source(value) {
    _source = value;
  }

  get namePortEnd => _namePortEnd;

  set namePortEnd(value) {
    _namePortEnd = value;
  }

  String get namePort => _namePort;

  set namePort(String value) {
    _namePort = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}
