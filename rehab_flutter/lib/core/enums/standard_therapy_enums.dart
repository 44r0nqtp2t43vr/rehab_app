enum StandardTherapy { bms, ims, pod, ptd, ttd }

StandardTherapy stringToStandardTherapyEnum(String name) {
  switch (name) {
    case "bms":
      return StandardTherapy.bms;
    case "ims":
      return StandardTherapy.ims;
    case "pod":
      return StandardTherapy.pod;
    case "ptd":
      return StandardTherapy.ptd;
    case "ttd":
      return StandardTherapy.ttd;
    default:
      return StandardTherapy.pod;
  }
}
