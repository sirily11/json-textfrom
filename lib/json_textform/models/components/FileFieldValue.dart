import 'dart:io';

class FileFieldValue {
  /// should clear the file
  bool willClear;

  /// Only not null when user pick a local file
  File _file;

  /// Web path
  String path;

  /// When file is set, this field will be true;
  bool hasUpdated;

  bool get isEmpty {
    if (path == null && _file == null) {
      return true;
    }

    return path.isEmpty;
  }

  /// Return [file] if file field has been set, otherwise return null;
  File get value {
    if (willClear && _file == null) {
      return null;
    }

    if (!hasUpdated) {
      return null;
    }

    return _file;
  }

  File get file => this._file;

  set file(File file) {
    this._file = file;
    if (file != null) {
      this.willClear = false;
      this.hasUpdated = true;
    }
  }

  void restoreOld() {
    this.willClear = false;
    if (_file == null) {
      this.hasUpdated = false;
    }
  }

  void clearOld() {
    this.hasUpdated = true;
    this.willClear = true;
  }

  void clearNew() {
    this._file = null;
    if (this.path != null) {
      if (!willClear) {
        this.hasUpdated = false;
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {"name": toString()};
  }

  @override
  String toString() {
    if (!hasUpdated) {
      return path;
    } else if (hasUpdated) {
      return _file?.path ?? path;
    } else {
      return "";
    }
  }

  FileFieldValue({this.path, this.hasUpdated = false, this.willClear = false});
}
